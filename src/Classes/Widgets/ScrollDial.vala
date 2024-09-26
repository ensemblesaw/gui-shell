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

        private KissFFT.Cfg cfg;
        private KissFFT.Cpx[] c_in;
        private KissFFT.Cpx[] c_out;
        private const float decay_factor = 0.05f;
        private bool had_audio = false;
        private const int nfft = 256;
        private const int nbars = 32;
        private float[] bars_l;
        private float[] previous_bars_l;
        private float[] bars_r;
        private float[] previous_bars_r;
        private int low_bin;
        private int high_bin;
        private int bins_per_bar;

        public ScrollDial (string? uri = "") {
            Object (
                name: "dial",
                accessible_role: Gtk.AccessibleRole.SCROLLBAR,
                uri: uri
            );
        }

        construct {
            cfg = KissFFT.alloc (nfft, false, null, null);
            c_in = new KissFFT.Cpx[nfft];
            c_out = new KissFFT.Cpx[nfft];

            bars_l = new float[nbars];
            previous_bars_l = new float[nbars];
            bars_r = new float[nbars];
            previous_bars_r = new float[nbars];

            // Convert desired frequency range to FFT bin indices
            low_bin = (int)(100 * nfft / 44100);
            high_bin = (int)(5800 * nfft / 44100);

            // Ensure bin indices are within valid bounds
            low_bin = low_bin > 0 ? low_bin : 0;
            high_bin = high_bin < nfft >> 1 ? high_bin : nfft >> 1;

            // Compute the number of FFT bins per bar
            bins_per_bar = (high_bin - low_bin) / nbars;

            build_layout ();
            realize.connect (() => {
                build_ui ();
            });
            build_events ();
        }

        public void animate_audio (float* buffer_l, float* buffer_r, int len) {

            if (buffer_l != null && buffer_r != null && len > 0) {
                // Fill in the input buffer with the audio samples
                for (int i = 0; i < nfft; i++) {
                    c_in[i].r = (i < len) ? buffer_l[i] : 0.0f;  // Zero-padding if buffer is smaller than nfft
                    c_in[i].i = 0.0f;  // Imaginary part is zero for real input
                }

                KissFFT.transform (cfg, c_in, c_out);

                // Fill the bars by grouping the FFT bins based on the logarithmic scale
                for (int i = 0; i < nbars; i++) {
                    float sum = 0.0f;

                    // Sum the magnitudes of the bins in this bar's frequency range
                    int start_bin = low_bin + i * bins_per_bar;
                    int end_bin = start_bin + bins_per_bar;

                    for (int j = start_bin; j < end_bin && j <= high_bin; j++) {
                        float magnitude = (c_out[j].r * c_out[j].r) + (c_out[j].i * c_out[j].i);
                        if (magnitude < 0) magnitude = 0;  // Ensure no negative magnitude
                        sum += magnitude;  // Magnitude of complex number
                    }

                    // Average and store in bars, avoiding division by zero
                    int band_size = end_bin - start_bin;
                    if (band_size > 0) {
                        bars_l[i] = sum / band_size;
                    } else {
                        bars_l[i] = 0.0f;  // Avoid division by zero
                    }

                    // Apply decay logic: if the new value is lower, apply decay
                    if (bars_l[i] < previous_bars_l[i]) {
                        bars_l[i] = previous_bars_l[i] * (1.0f - decay_factor);
                    }

                    //  Clamp small values to zero to avoid persistent small bars
                    if (bars_l[i] < 0.001) {
                        bars_l[i] = 0.0f;
                    }

                    // Update the previous_bars array with the current value
                    previous_bars_l[i] = bars_l[i];

                    // Check for NaN values and filter them out
                    if (bars_l[i].is_nan ()) {
                        bars_l[i] = 0.0f;  // Replace NaN with 0
                    } else {
                        bars_l[i] /= 20;
                    }
                }

                // Fill in the input buffer with the audio samples
                for (int i = 0; i < nfft; i++) {
                    c_in[i].r = (i < len) ? buffer_r[i] : 0.0f;  // Zero-padding if buffer is smaller than nfft
                    c_in[i].i = 0.0f;  // Imaginary part is zero for real input
                }

                KissFFT.transform (cfg, c_in, c_out);

                // Fill the bars by grouping the FFT bins based on the logarithmic scale
                for (int i = 0; i < nbars; i++) {
                    float sum = 0.0f;

                    // Sum the magnitudes of the bins in this bar's frequency range
                    int start_bin = low_bin + i * bins_per_bar;
                    int end_bin = start_bin + bins_per_bar;

                    for (int j = start_bin; j < end_bin && j <= high_bin; j++) {
                        float magnitude = (c_out[j].r * c_out[j].r) + (c_out[j].i * c_out[j].i);
                        if (magnitude < 0) magnitude = 0;  // Ensure no negative magnitude
                        sum += magnitude;  // Magnitude of complex number
                    }

                    // Average and store in bars, avoiding division by zero
                    int band_size = end_bin - start_bin;
                    if (band_size > 0) {
                        bars_r[i] = sum / band_size;
                    } else {
                        bars_r[i] = 0.0f;  // Avoid division by zero
                    }

                    // Apply decay logic: if the new value is lower, apply decay
                    if (bars_r[i] < previous_bars_r[i]) {
                        bars_r[i] = previous_bars_r[i] * (1.0f - decay_factor);
                    }

                    //  Clamp small values to zero to avoid persistent small bars
                    if (bars_r[i] < 0.001) {
                        bars_r[i] = 0.0f;
                    }

                    // Update the previous_bars array with the current value
                    previous_bars_r[i] = bars_r[i];

                    // Check for NaN values and filter them out
                    if (bars_r[i].is_nan ()) {
                        bars_r[i] = 0.0f;  // Replace NaN with 0
                    } else {
                        bars_r[i] /= 20;
                    }
                }
            }
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
                if (visible && width != get_width ()) {
                    width = get_width ();

                    height_request = width;
                    radius = width / 2;
                    socket_radius = (int) (radius * 0.22);
                    dial_socket_graphic.width_request = socket_radius << 1;
                    dial_socket_graphic.height_request = socket_radius << 1;
                    width_changed (width);
                    rotate_dial (value);
                }

                dial_meter.queue_draw ();

                return update;
            });
        }


        protected void draw_meter (Gtk.DrawingArea meter, Cairo.Context ctx, int width, int height) {
            if (!visible) {
                return;
            }

            bool has_audio = false;
            double angle_step = Math.PI / nbars;  // Angle between each pie for 32 groups



                //      if (sum > 0.1) {
                //          has_audio = true;
                //      }
                uint _radius = radius - 2;
                for (int i = 0; i < nbars; i++) {
                    if (bars_l[i] > 0.1) {
                        has_audio = true;
                    }
                    ctx.move_to((width >> 1) + 0.25, (height >> 1) + 0.25);  // Move to center of the circle

                    // Draw the two lines that form the wedge
                    ctx.arc((width >> 1) + 0.25, (height >> 1) + 0.25, _radius, i * angle_step + Math.PI_2, (i + 1) * angle_step + Math.PI_2);

                    // Close the path to create the wedge shape
                    ctx.close_path();

                    // Fill the pie segment
                    ctx.set_source_rgba(0, 0, 0, (1 - (bars_l[i] < 0 ? -bars_l[i] : bars_l[i])));
                    ctx.fill ();

                    ctx.set_source_rgba(0, 0, 0, (1 - (bars_l[i] < 0 ? -bars_l[i] : bars_l[i])));
                    ctx.set_line_width (1);
                    ctx.stroke ();
                }

                for (int i = 0; i < 32; i++) {
                    if (bars_l[i] > 0.1) {
                        has_audio = true;
                    }
                    // Use the calculated average for this group
                    double avg = bars_r[31 - i];
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
