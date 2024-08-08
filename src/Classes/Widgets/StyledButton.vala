/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Widgets {
    public class MIDIControllableButton: Gtk.Button, ContextMenuTrigger, MIDIControllable {
        public string uri { get; construct; }
        public uint16 route_id { get; set; }
        public Gtk.GestureClick click_gesture { get; private set; }
        public Gtk.GestureLongPress long_press_gesture { get; private set; }

        public MIDIControllableButton (string? uri) {
            Object (uri: uri);
        }

        public MIDIControllableButton.with_label (string? uri, string? text) {
            Object (
                uri: uri,
                label: text
            );
        }

        public MIDIControllableButton.from_icon_name (string? uri, string? icon_name) {
            Object (
                uri: uri,
                icon_name: icon_name
            );
        }

        construct {
            build_events ();
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
