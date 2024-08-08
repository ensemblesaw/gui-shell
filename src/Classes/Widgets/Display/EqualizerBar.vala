/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */


namespace Ensembles.GtkShell.Widgets.Display {
    public class EqualizerBar : Gtk.DrawingArea {
        //  DrawingArea drawing_area;
        private int _level;
        public int level {
            get {
                return _level;
            }
            set {
                _level = 127 - value;
                Idle.add (() => {
                    queue_draw ();
                    return false;
                });
            }
        }

        public float r { get; set; }
        public float g { get; set; }
        public float b { get; set; }

        public EqualizerBar () {
            level = 0;

            Object (
                height_request: 42,
                level: 0,
                hexpand: true,
                vexpand: true
            );

            r = 1;
            g = 1;
            b = 1;

            add_css_class ("equalizer-bar");

            set_draw_func (draw);
        }

        protected void draw (Gtk.DrawingArea meter, Cairo.Context cr, int width, int height) {
            if (width > 0 && height > 0) {
                double degrees = Math.PI / 180.0;
                double radius = 6.0;
                cr.new_sub_path ();
                cr.arc (width - radius, radius, radius, -90 * degrees, 0);
                cr.arc (width - radius, height - radius, radius, 0, 90 * degrees);
                cr.arc (radius, height - radius, radius, 90 * degrees, 180 * degrees);
                cr.arc (radius, radius, radius, 180 * degrees, 270 * degrees);
                cr.close_path ();

                cr.clip ();
            }

            cr.move_to (0, 0);

            var bar_height = Math.floor ((height + 1) / 7);
            cr.set_source_rgba (0.6, 0.6, 0.6, 0.2);
            for (int i = 0; i < 7; i++) {
                cr.rectangle (0, i * bar_height, width, bar_height - 1);
            }

            cr.fill ();
            cr.set_source_rgba (r, g, b, 1);
            for (int i = 6; i >= 0; i--) {
                cr.rectangle (0, i * bar_height, width, bar_height - 1);
                if (i * 16 < _level) {
                    break;
                }

                cr.fill ();
            }
        }
    }
}
