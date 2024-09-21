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

        private int width;
        private bool update = true;

        private float scroll_location;

        protected signal void width_changed (double width);

        private uint radius = 0;

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
                dial_socket_graphic = new Gtk.Box (VERTICAL, 0) {
                    width_request = 20,
                    height_request = 20
                };
                dial_socket_graphic.add_css_class ("dial-socket-graphic");

                var fixed = new Gtk.Fixed () {
                    hexpand = true,
                    vexpand = true
                };
                fixed.set_parent (this);
                fixed.put (dial_socket_graphic, 60, 50);
            }
        }

        private void build_events () {
            add_tick_callback (() => {
                if (width != get_width ()) {
                    width = get_width ();

                    height_request = width;
                    radius = width / 2;
                    dial_meter.queue_draw ();
                    width_changed (width);
                }

                return update;
            });
        }

        protected void draw_meter (Gtk.DrawingArea meter, Cairo.Context ctx, int width, int height) {

        }
    }
}
