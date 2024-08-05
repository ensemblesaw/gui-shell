/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */


namespace Ensembles.GtkShell.Widgets.Display {
    public class GraphicalModulator : Gtk.Box {
        private Gtk.Box speaker_l;
        private Gtk.Box speaker_r;
        private Gtk.DrawingArea reverb_gfx;
        private Gtk.Fixed listener_area;
        private Gtk.Box listener;

        private int width;
        private int height;
        private bool update;

        private uint8 _reverb = 0;
        public uint8 reverb {
            get {
                return _reverb;
            }

            set {
                _reverb = value;
                reverb_gfx.queue_draw ();
            }
        }

        private uint8 _pan = 63;
        public uint8 pan {
            get {
                return _pan;
            }

            set {
                _pan = value;
                position_listener ();
                reverb_gfx.queue_draw ();
            }
        }

        private uint8 _chorus = 0;
        public uint8 chorus {
            get {
                return _chorus;
            }

            set {
                _chorus = value;
                position_listener ();
                reverb_gfx.queue_draw ();
            }
        }

        private uint8 _brightness = 0;
        public uint8 brightness {
            get {
                return _brightness;
            }

            set {
                _brightness = value;
                set_color ((int) (value * 10.0 / 128.0));
            }
        }

        public GraphicalModulator () {
            Object (
                hexpand: true,
                vexpand: true
            );
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            add_css_class ("graphical-modulator");

            var overlay = new Gtk.Overlay ();
            append (overlay);

            var speaker_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2) {
                homogeneous = true,
                vexpand = true
            };
            overlay.set_child (speaker_box);

            speaker_l = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                vexpand = true,
                hexpand = true
            };
            speaker_l.add_css_class ("graphical-modulator-speaker-l");
            speaker_box.append (speaker_l);

            speaker_r = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                vexpand = true,
                hexpand = true
            };
            speaker_r.add_css_class ("graphical-modulator-speaker-r");
            speaker_box.append (speaker_r);

            reverb_gfx = new Gtk.DrawingArea () {
                hexpand = true,
                vexpand = true
            };
            overlay.add_overlay (reverb_gfx);
            reverb_gfx.set_draw_func (draw);

            listener_area = new Gtk.Fixed () {
                hexpand = true,
                vexpand = true
            };
            overlay.add_overlay (listener_area);

            listener = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                width_request = 32,
                height_request = 32
            };
            listener_area.put (listener, 0, 0);
            listener.add_css_class ("graphical-modulator-listener");

            update = true;

            Timeout.add (80, () => {
                Idle.add (() => {
                    if (width != get_width () || height != get_height ()) {
                        position_listener ();
                        reverb_gfx.queue_draw ();

                        width = get_width ();
                        height = get_height ();
                    }

                    return false;
                }, Priority.LOW);
                return update;
            }, Priority.LOW);
        }

        private void build_events () {
            this.destroy.connect (() => {
                update = false;
            });
        }

        private void position_listener () {
            int pan_x = (int) ((get_width () - 32.0) * (pan / 127.0));
            int chorus_y = (int) (48 + ((get_height () - 80.0) * (chorus / 127.0)));

            listener_area.move (listener, pan_x, chorus_y);
        }

        private void draw (Gtk.DrawingArea meter, Cairo.Context cr, int width, int height) {
            int reverb_radius = (int) ((Math.fmin (width, height) / 2.0) * ((reverb + 16.0) / 133.0));
            int pan_x = (int) (16 + ((get_width () - 32.0) * (pan / 127.0)));
            int chorus_y = (int) (64 + ((get_height () - 80.0) * (chorus / 127.0)));

            cr.arc (pan_x, chorus_y, reverb_radius, 0, 2 * Math.PI);
            cr.set_line_width (1);
            cr.set_source_rgba (1, 1, 1, 0.2);
            cr.stroke ();
        }

        public void set_color (int int_val) {
            GLib.Idle.add (() => {
                for (int i = 0; i <= 10; i++) {
                    if (i != int_val) {
                        remove_css_class (("b-%d").printf (i));
                    }
                }

                add_css_class (("b-%d").printf (int_val));

                return false;
            });
        }
    }
}
