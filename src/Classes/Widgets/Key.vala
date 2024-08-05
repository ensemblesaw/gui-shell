/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Widgets {
    public class Key : Gtk.Box {
        public uint8 index { get; protected set; }
        public bool is_black { get; protected set; }
        private Gtk.GestureDrag motion_controller;
        private Gtk.GestureClick click_gesture;

        /** The color the keys are meant to show */
        public enum IlluminationColor {
            /** Default illumination color when key is pressed, matches accent color of the OS */
            ACCENT = 0x00,
            /** Default illumination when chords or keyboard split is used */
            COMPLEMENTARY = 0x01,
            /** Default illumination color when automated MIDI events are shown */
            AUTOMATION = 0x02,
            /** Guides user by showing scale, chords, etc */
            GUIDE = 0x03,
            /** Custom color from elementary OS HIG */
            STRAWBERRY = 0x04,
            /** Custom color from elementary OS HIG */
            ORANGE = 0x05,
            /** Custom color from elementary OS HIG */
            BANANA = 0x06,
            /** Custom color from elementary OS HIG */
            LIME = 0x07,
            /** Custom color from elementary OS HIG */
            MINT = 0x08,
            /** Custom color from elementary OS HIG */
            BLUEBERRY = 0x09,
            /** Custom color from elementary OS HIG */
            GRAPE = 0x0A,
            /** Custom color from elementary OS HIG */
            BUBBLEGUM = 0x0B,
            /** Custom color from elementary OS HIG */
            COCOA = 0x0C,
            /** Custom color from elementary OS HIG */
            SILVER = 0x0D
        }

        private IlluminationColor _illumination_color;

        /**
         * The color to use for illumination
         */
        public IlluminationColor illumination_color {
            get {
                return _illumination_color;
            }
            set {
                _illumination_color = value;
                for (uint8 i = 0; i < 14; i++) {
                    if (i != value) {
                        remove_css_class ("_%u".printf (i));
                    }
                }

                add_css_class ("_%u".printf (illumination_color));
            }
        }

        private bool _illuminated;

        /**
         * Whether the key is illuminated
         */
        public bool illuminated {
            get {
                return _illuminated;
            }
            set {
                _illuminated = value;
                if (value) {
                    add_css_class ("illuminated");
                } else {
                    remove_css_class ("illuminated");
                    for (uint8 i = 1; i < 14; i++) {
                        remove_css_class ("_%u".printf (i));
                    }
                }
            }
        }

        public signal void pressed (uint8 index);
        public signal void released (uint8 index);
        public signal void motion (uint8 index, double x, double y);

        public Key (uint8 index, bool is_black) {
            Object (
                index: index,
                is_black: is_black
            );

            if (is_black) {
                add_css_class ("black");
            }
        }

        construct {
            build_ui ();
            build_event ();
        }

        private void build_ui () {
            add_css_class ("key");
        }

        private void build_event () {
            motion_controller = new Gtk.GestureDrag ();
            add_controller (motion_controller);

            click_gesture = new Gtk.GestureClick ();
            click_gesture.pressed.connect ((n_press, x, y) => {
                pressed (index);
            });
            click_gesture.released.connect (() => {
                released (index);
            });

            motion_controller.drag_update.connect ((x, y) => {
                if (illuminated) {
                    this.motion (index, x / get_allocated_width (), y / get_allocated_height ());
                }
            });
            add_controller (click_gesture);
        }

        public bool inside (Octave parent, double x, double y) {
            double _x, _y;
            parent.translate_coordinates (this, x, y, out _x, out _y);
            return contains (_x, _y);
        }
    }
}
