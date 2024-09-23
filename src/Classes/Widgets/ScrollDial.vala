/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Widgets {
     /**
      * A `ScrollDial` is a rotary control used to scroll inside `WheelScrollableWidget`s.
      */
    public class ScrollDial : Gtk.Widget, Gtk.Accessible, MIDIControllable {
        // Knob UI
        private Gtk.BinLayout bin_layout;
        protected Gtk.Box dial_light_graphics;
        protected Gtk.Box dial_socket_graphic;
        protected Gtk.Box dial_cover;
        protected Gtk.DrawingArea dial_meter;
        protected Gtk.Box dial_background;
        private Gtk.Fixed fixed;

        private Gtk.GestureRotate touch_rotation_gesture;
        private Gtk.GestureDrag drag_gesture;
        private Gtk.EventControllerScroll wheel_gesture;

        private int width;
        private bool update = true;
        private double current_deg;
        private double previous_deg;

        private float scroll_location;

        protected signal void width_changed (double width);

        private uint radius = 0;
        private int socket_radius = 10;
        public double value = 0;

        private float* buffer_l;
        private float* buffer_r;
        private int buffer_len = 0;
        private float[] averages;
        private bool had_audio = false;

        public ScrollDial (string? uri = "") {
            Object (
                name: "dial",
                accessible_role: Gtk.AccessibleRole.SCROLLBAR,
                uri: uri
            );
        }

        construct {
            build_layout ();
            realize.connect (() => {
                build_ui ();
            });
            build_events ();
        }

        public void animate_audio (float* buffer_l, float* buffer_r, int len) {
            this.buffer_l = buffer_l;
            this.buffer_r = buffer_r;
            buffer_len = len;
        }

        private void build_layout () {
            bin_layout = new Gtk.BinLayout ();
            set_layout_manager (bin_layout);
        }

        private void build_ui () {
            add_css_class ("scroll-dial");

            var width = get_allocated_width () | width_request;
            var height = get_allocated_height () | height_request;

            var diameter = width < height ? width : height;

            radius = diameter / 2;

            if (dial_meter == null) {
                dial_meter = new Gtk.DrawingArea () {
                    hexpand = true,
                    vexpand = true
                };
                dial_meter.set_draw_func (draw_meter);
                dial_meter.set_parent (this);
                dial_meter.add_css_class ("dial-meter");
            }

            if (dial_light_graphics == null) {
                dial_light_graphics = new Gtk.Box (VERTICAL, 0) {
                    hexpand = true,
                    vexpand = true
                };
                dial_light_graphics.add_css_class ("dial-light-graphic");
                dial_light_graphics.set_parent (this);
            }

            if (dial_cover == null) {
                dial_cover = new Gtk.Box (VERTICAL, 0) {
                    hexpand = true,
                    vexpand = true
                };
                dial_cover.add_css_class ("dial-cover-graphic");
                dial_cover.set_parent (this);
            }

            if (dial_socket_graphic == null) {
                socket_radius = (int) (radius * 0.22);
                dial_socket_graphic = new Gtk.Box (VERTICAL, 0) {
                    width_request = socket_radius << 1,
                    height_request = socket_radius << 1
                };
                dial_socket_graphic.add_css_class ("dial-socket-graphic");

                fixed = new Gtk.Fixed () {
                    hexpand = true,
                    vexpand = true
                };
                fixed.set_parent (this);
                fixed.put (dial_socket_graphic, 60, 50);
                rotate_dial (0);
            }
        }

        private void build_events () {
            drag_gesture = new Gtk.GestureDrag () {
                propagation_phase = Gtk.PropagationPhase.CAPTURE,
                name = "drag-rotation-capture"
            };
            add_controller (drag_gesture);

            drag_gesture.drag_begin.connect ((x, y) => {
                previous_deg = Math.atan2 (x - radius, y - radius) * (180 / Math.PI);
            });

            drag_gesture.drag_update.connect ((x, y) => {
                double start_x;
                double start_y;
                drag_gesture.get_start_point (out start_x, out start_y);

                double relative_x = start_x + x;
                double relative_y = start_y + y;

                current_deg = Math.atan2 (relative_x - radius, relative_y - radius) * (180 / Math.PI);

                var delta_deg = previous_deg - current_deg;

                previous_deg = current_deg;

                rotate_dial (value += delta_deg);
            });

            add_tick_callback (() => {
                if (width != get_width ()) {
                    width = get_width ();

                    height_request = width;
                    radius = width / 2;
                    socket_radius = (int) (radius * 0.22);
                    dial_socket_graphic.width_request = socket_radius << 1;
                    dial_socket_graphic.height_request = socket_radius << 1;
                    width_changed (width);
                }

                dial_meter.queue_draw ();

                return update;
            });
        }


        protected void draw_meter (Gtk.DrawingArea meter, Cairo.Context ctx, int width, int height) {
            bool has_audio = false;

            if (buffer_l != null && buffer_r != null && buffer_len > 0) {
                int total_averages = 32;
                int total_elements = total_averages * (buffer_len / total_averages);  // Use only the first part divisible by 32
                int group_size = total_elements / total_averages;  // Each group will have equal elements (ignoring the last ones)
                uint _radius = radius - 2;

                // Calculate averages for 32 groups from buffer_l
                averages = new float[total_averages];
                for (int i = 0; i < total_averages; i++) {
                    float sum = 0.0f;
                    for (int j = 0; j < group_size; j++) {
                        sum += buffer_l[i * group_size + j];
                    }

                    averages[i] = 5 * sum / group_size;
                    if (averages[i] > 0.1) {
                        has_audio = true;
                    }
                }

                // Now, draw the meter using the averages instead of individual buffer values
                double angle_step = Math.PI / total_averages;  // Angle between each pie for 32 groups

                for (int i = 0; i < 32; i++) {
                    // Use the calculated average for this group
                    double avg = averages[i];


                    // Start drawing each pie
                    ctx.move_to((width >> 1) + 0.25, (height >> 1) + 0.25);  // Move to center of the circle

                    // Draw the two lines that form the wedge
                    ctx.arc((width >> 1) + 0.25, (height >> 1) + 0.25, _radius, i * angle_step + Math.PI_2, (i + 1) * angle_step + Math.PI_2);

                    // Close the path to create the wedge shape
                    ctx.close_path();

                    // Fill the pie segment
                    ctx.set_source_rgba(0, 0, 0, (1 - (avg < 0 ? -avg : avg)));
                    ctx.fill ();

                    ctx.set_source_rgba(0, 0, 0, (1 - (avg < 0 ? -avg : avg)));
                    ctx.set_line_width (1);
                    ctx.stroke ();
                }

                // Calculate averages for 32 groups from buffer_r
                averages = new float[total_averages];
                for (int i = 0; i < total_averages; i++) {
                    float sum = 0.0f;
                    for (int j = 0; j < group_size; j++) {
                        sum += buffer_r[i * group_size + j];
                    }

                    averages[i] = 5 * sum / group_size;
                    if (averages[i] > 0.1) {
                        has_audio = true;
                    }
                }

                for (int i = 0; i < 32; i++) {
                    // Use the calculated average for this group
                    double avg = averages[32 - i];
                    ctx.set_source_rgba(0, 0, 0, (1 - (avg < 0 ? -avg : avg)));

                    // Start drawing each pie
                    ctx.move_to((width >> 1) + 0.25, (height >> 1) + 0.25);  // Move to center of the circle

                    // Draw the two lines that form the wedge
                    ctx.arc((width >> 1) + 0.25, (height >> 1) + 0.25, _radius, i * angle_step - Math.PI_2, (i + 1) * angle_step - Math.PI_2);

                    // Close the path to create the wedge shape
                    ctx.close_path();

                    // Fill the pie segment
                    ctx.fill ();
                }
            } else {
                // Draw a full black circle if buffer data is not available
                ctx.set_source_rgb(0, 0, 0);
                ctx.arc((width >> 1) + 0.5, (height >> 1) + 0.5, radius, 0, 2 * Math.PI);  // Draw the circle path
                ctx.fill();
                has_audio = false;
            }

            if (has_audio != had_audio) {
                had_audio = has_audio;

                if (has_audio) {
                    add_css_class ("has-audio");
                } else {
                    remove_css_class ("has-audio");
                }
            }
        }


        private void rotate_dial (double value) {
            uint _radius = radius >> 1;
            double px = _radius * GLib.Math.cos (value * (Math.PI / 180));
            double py = _radius * GLib.Math.sin (value * (Math.PI / 180));
            Idle.add (() => {
                fixed.move (dial_socket_graphic, (int)(px + radius - socket_radius + 1), (int)(py + radius - socket_radius + 1));
                fixed.queue_draw ();
                return false;
            });
        }
    }
}
