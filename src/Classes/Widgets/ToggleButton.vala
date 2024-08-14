/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Widgets {
    public class ToggleButton : MIDIControllableButton {
        private Gtk.Label text_label;
        private Gtk.Box indicator_box;
        private bool _active = false;
        public bool active {
            get {
                return _active;
            }
            set {
                _active = value;
                if (_active) {
                    indicator_box.add_css_class ("toggle-indicator-active");
                } else {
                    indicator_box.remove_css_class ("toggle-indicator-active");
                }
            }
        }

        public signal void toggled (bool active);

        public ToggleButton (string label, string? uri = "") {
            Object (
                uri: uri
            );

            text_label = new Gtk.Label (label);
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            set_child (box);

            box.append (text_label);

            indicator_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                height_request = 4
            };

            indicator_box.add_css_class ("toggle-indicator");
            box.append (indicator_box);

            remove_css_class ("toggle");
            add_css_class ("toggle-switch");
        }

        private void build_events () {
            clicked.connect (() => {
                active = !active;
                toggled (active);
            });
        }
    }
}
