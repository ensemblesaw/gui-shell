/*
 * Copyright 2020-2022 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.Models;

namespace Ensembles.GtkShell {
    public class Drumkit : Gtk.Widget, Gtk.Accessible {

        private bool update = true;
        private int width;
        private int height;

        private Gtk.Button highhat_button;
        private Gtk.Button snare_button;
        private Gtk.Button thin_cymbal_button;
        private Gtk.Button kick_button;
        private Gtk.Button high_tom_button;
        private Gtk.Button mid_tom_button;
        private Gtk.Button crash_cymbal_button;
        private Gtk.Button floor_tom_button;
        private const double HIGHHAT_ASPECT_RATIO = 0.444444;
        private const double SNARE_ASPECT_RATIO = 0.6592593;
        private const double THIN_CYMBAL_ASPECT_RATIO = 0.42962963;
        private const double KICK_ASPECT_RATIO = 0.93333333;
        private const double HIGH_TOM_ASPECT_RATIO = 0.26666666;
        private const double MID_TOM_ASPECT_RATIO = 0.407407;
        private const double CRASH_CYMBAL_ASPECT_RATIO = 0.607407;
        private const double FLOOR_TOM_ASPECT_RATIO = 0.481481;

        // Two click gestures to support upto two simultaneous touches
        private Gtk.GestureClick click_gesture_1;
        private Gtk.GestureClick click_gesture_2;

        public signal void drum_event (MIDIEvent midi_event);

        public Drumkit () {
            Object (
                accessible_role: Gtk.AccessibleRole.TABLE,
                name: "drumkit",
                css_name: "drumkit",
                layout_manager: new Gtk.BoxLayout (Gtk.Orientation.HORIZONTAL),
                height_request: 100
            );
        }

        ~Drumkit () {
            update = false;
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            var fixed = new Gtk.Fixed () {
                margin_start = 8
            };
            fixed.set_parent (this);

            thin_cymbal_button = new Gtk.Button ();
            thin_cymbal_button.add_css_class ("drumkit-thin-cymbal");
            fixed.put (thin_cymbal_button, 20, 0);

            floor_tom_button = new Gtk.Button ();
            floor_tom_button.add_css_class ("drumkit-floor-tom");
            fixed.put (floor_tom_button, 20, 0);

            kick_button = new Gtk.Button ();
            kick_button.add_css_class ("drumkit-kick");
            fixed.put (kick_button, 40, 0);

            snare_button = new Gtk.Button ();
            snare_button.add_css_class ("drumkit-snare");
            fixed.put (snare_button, 20, 0);

            high_tom_button = new Gtk.Button ();
            high_tom_button.add_css_class ("drumkit-high-tom");
            fixed.put (high_tom_button, 20, 0);

            mid_tom_button = new Gtk.Button ();
            mid_tom_button.add_css_class ("drumkit-mid-tom");
            fixed.put (mid_tom_button, 20, 0);

            crash_cymbal_button = new Gtk.Button ();
            crash_cymbal_button.add_css_class ("drumkit-crash-cymbal");
            fixed.put (crash_cymbal_button, 20, 0);

            highhat_button = new Gtk.Button ();
            highhat_button.add_css_class ("drumkit-highhat");
            fixed.put (highhat_button, 0, 0);

            Timeout.add (80, () => {
                Idle.add (() => {
                    if (width != get_width () || height != get_height ()) {
                        // Update content here upon resize:
                        var __height = parent.get_height () - 2;

                        highhat_button.height_request = __height;
                        highhat_button.width_request = (int) (__height * HIGHHAT_ASPECT_RATIO);

                        fixed.move (snare_button, highhat_button.width_request * 0.36, 0);
                        snare_button.height_request = __height;
                        snare_button.width_request = (int) (__height * SNARE_ASPECT_RATIO);

                        fixed.move (thin_cymbal_button, highhat_button.width_request * 0.3, 0);
                        thin_cymbal_button.width_request = (int) (__height * THIN_CYMBAL_ASPECT_RATIO);
                        thin_cymbal_button.height_request = __height;

                        fixed.move (kick_button, highhat_button.width_request * 0.5, 0);
                        kick_button.width_request = (int) (__height * KICK_ASPECT_RATIO);
                        kick_button.height_request = __height;

                        fixed.move (high_tom_button, highhat_button.width_request * 0.94, 0);
                        high_tom_button.width_request = (int) (__height * HIGH_TOM_ASPECT_RATIO);
                        high_tom_button.height_request = __height;

                        fixed.move (mid_tom_button, highhat_button.width_request * 1.45, 0);
                        mid_tom_button.width_request = (int) (__height * MID_TOM_ASPECT_RATIO);
                        mid_tom_button.height_request = __height;

                        fixed.move (floor_tom_button, highhat_button.width_request * 1.72, 0);
                        floor_tom_button.width_request = (int) (__height * FLOOR_TOM_ASPECT_RATIO);
                        floor_tom_button.height_request = __height;

                        fixed.move (crash_cymbal_button, highhat_button.width_request * 1.72, 0);
                        crash_cymbal_button.width_request = (int) (__height * CRASH_CYMBAL_ASPECT_RATIO);
                        crash_cymbal_button.height_request = __height;

                        width = get_width ();
                        height = __height;
                    }

                    return false;
                }, Priority.LOW);
                return update;
            }, Priority.LOW);
        }

        public void animate (uint8 key_index, bool active) {
            print(key_index.to_string ());
            if (active) {
                switch (key_index) {
                    case 35:
                    case 36:
                        kick_button.add_css_class ("active");
                        break;
                    case 40:
                        snare_button.add_css_class ("active");
                        break;
                    case 42:
                    case 44:
                        highhat_button.add_css_class ("closed");
                        break;
                    case 46:
                        highhat_button.add_css_class ("active");
                        break;
                }
            } else {
                switch (key_index) {
                    case 35:
                    case 36:
                        kick_button.remove_css_class ("active");
                        break;
                    case 40:
                        snare_button.remove_css_class ("active");
                        break;
                    case 42:
                    case 44:
                        highhat_button.remove_css_class ("closed");
                        break;
                    case 46:
                        highhat_button.remove_css_class ("active");
                        break;
                }
            }
        }

        private void build_events () {
            click_gesture_1 = new Gtk.GestureClick () {
                name = "drumkit-gesture",
                propagation_phase = Gtk.PropagationPhase.CAPTURE
            };

            click_gesture_1.pressed.connect ((n, x, y) => {
                handle_touch_start (x, y);
                click_gesture_2.propagation_phase = Gtk.PropagationPhase.CAPTURE;
            });

            click_gesture_1.released.connect ((n, x, y) => {
                click_gesture_2.propagation_phase = Gtk.PropagationPhase.BUBBLE;
                handle_touch_end (x, y);
            });

            add_controller (click_gesture_1);

            click_gesture_2 = new Gtk.GestureClick () {
                name = "drumkit-gesture",
                propagation_phase = Gtk.PropagationPhase.BUBBLE
            };

            click_gesture_2.pressed.connect ((n, x, y) => {
                handle_touch_start (x, y);
            });

            click_gesture_2.released.connect ((n, x, y) => {
                handle_touch_end (x, y);
            });

            add_controller (click_gesture_2);
        }

        private void handle_touch_start (double x, double y) {
            double _y = y / get_height ();
            double _x = (x - 8) / get_height ();
            print("Start %lf %lf\n", _x, _y);

            // HIGH HAT
            if (_x > 0.1156 && _x < 0.396 && _y > 0.718) {
                ui_hit (44);
            } else if (_x > 0.026 && _x < 0.238 && _y > 0.46 && _y < 0.718) {
                ui_hit (42);
            } else if (_x < 0.297 && _y > 0.33 && _y < 0.488) {
                ui_hit (46);
            }
            // SNARE
            else if (_x > 0.26 && _x < 0.47 && _y > 0.443 && _y < 0.678) {
                ui_hit (40);
            }
            // THIN CYMBAL
            else if (_x > 0.195 && _x < 0.476 && _y > 0.095 && _y < 0.313) {
                ui_hit (57);
            }
            // CRASH CYMBAL
            else if (_x > 0.888 && _x < 1.25 && _y > 0.05 && _y < 0.325) {
                ui_hit (49);
            }
            // HIGH TOM
            else if (_x > 0.468 && _x < 0.633 && _y > 0.308 && _y < 0.473) {
                ui_hit (45);
            }
            // MID TOM
            else if (_x > 0.743 && _x < 0.935 && _y > 0.264 && _y < 0.5126) {
                ui_hit (43);
            }
            // MID TOM
            else if (_x > 0.85 && _x < 1.153 && _y > 0.5126) {
                ui_hit (41);
            }
            // KICK
            else if (_x > 0.5333 && _x < 0.85 && _y > 0.518) {
                ui_hit (36);
            }
        }

        private void handle_touch_end (double x, double y) {
            double _y = y / get_height ();
            double _x = (x - 8) / get_height ();

            // HIGH HAT
            if (_x > 0.1156 && _x < 0.396 && _y > 0.718) {
                ui_unhit (44);
            } else if (_x > 0.026 && _x < 0.238 && _y > 0.46 && _y < 0.718) {
                ui_unhit (42);
            } else if (_x < 0.297 && _y > 0.33 && _y < 0.488) {
                ui_unhit (46);
            }
            // SNARE
            else if (_x > 0.26 && _x < 0.47 && _y > 0.443 && _y < 0.678) {
                ui_unhit (40);
            }
            // THIN CYMBAL
            else if (_x > 0.195 && _x < 0.476 && _y > 0.095 && _y < 0.313) {
                ui_unhit (57);
            }
            // CRASH CYMBAL
            else if (_x > 0.888 && _x < 1.25 && _y > 0.05 && _y < 0.325) {
                ui_unhit (49);
            }
            // HIGH TOM
            else if (_x > 0.468 && _x < 0.633 && _y > 0.308 && _y < 0.473) {
                ui_unhit (45);
            }
            // MID TOM
            else if (_x > 0.743 && _x < 0.935 && _y > 0.264 && _y < 0.5126) {
                ui_unhit (43);
            }
            // MID TOM
            else if (_x > 0.85 && _x < 1.153 && _y > 0.5126) {
                ui_unhit (41);
            }
            // KICK
            else if (_x > 0.5333 && _x < 0.85 && _y > 0.518) {
                ui_unhit (36);
            }
        }

        private void ui_hit(uint8 key) {
            var event = new MIDIEvent ()
            .on_channel (17) // Channel 17 handles user key events
            .of_type (MIDIEvent.EventType.NOTE_ON)
            .with_key (key)
            .of_velocity (100);
            drum_event (event);
        }

        private void ui_unhit (uint8 key) {
            var event = new MIDIEvent ()
            .on_channel (17) // Channel 17 handles user key events
            .of_type (MIDIEvent.EventType.NOTE_OFF)
            .with_key (key);
            drum_event (event);
        }
    }
}
