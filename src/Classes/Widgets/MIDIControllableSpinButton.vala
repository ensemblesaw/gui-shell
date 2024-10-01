/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

 namespace Ensembles.GtkShell.Widgets {
    public class MIDIControllableSpinButton: Gtk.Box, ContextMenuTrigger, MIDIControllable {
        public string uri { get; construct; }
        public uint16 route_id { get; set; }
        public Gtk.GestureClick click_gesture { get; private set; }
        public Gtk.GestureLongPress long_press_gesture { get; private set; }

        private Gtk.SpinButton spin_button;
        public Gtk.Adjustment adjustment { get; set construct; }

        public MIDIControllableSpinButton (string? uri, Gtk.Adjustment? adjustment) {
            Object (
                uri: uri,
                adjustment: adjustment
            );
        }

        public MIDIControllableSpinButton.with_range (string? uri, double min, double max, double step, double default_value) {
            Object (
                uri: uri,
                adjustment: new Gtk.Adjustment (
                    default_value,
                    min,
                    max,
                    step,
                    1,
                    1
                )
            );
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            spin_button = new Gtk.SpinButton (adjustment, 1, 0) {
                hexpand = true
            };

            append (spin_button);
        }

        private void build_events () {
            click_gesture = new Gtk.GestureClick () {
                button = 3
            };
            add_controller (click_gesture);

            long_press_gesture = new Gtk.GestureLongPress ();
            add_controller (long_press_gesture);

            click_gesture.pressed.connect (() => {
                menu_activated ();
            });

            long_press_gesture.pressed.connect (() => {
                menu_activated ();
            });
        }
    }
}
