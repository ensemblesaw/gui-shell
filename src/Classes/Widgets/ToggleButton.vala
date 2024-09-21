/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Widgets {
    public class ToggleButton : MIDIControllableButton {
        private Gtk.Label text_label;
        private Gtk.Box indicator_box;
        public string label_text { get; set construct; }
        private bool _active = false;
        public bool active {
            get {
                return _active;
            }
            set {
                _active = value;
                if (_active) {
                    indicator_box.add_css_class ("active");
                } else {
                    indicator_box.remove_css_class ("active");
                }
            }
        }

        public signal void toggled (bool active);

        public ToggleButton (string? uri = "", string text) {
            Object (
                uri: uri,
                label_text: text
            );
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2) {
                vexpand = true
            };
            set_child (box);

            text_label =new Gtk.Label (label_text) {
                vexpand = true,
                valign = Gtk.Align.CENTER
            };
            box.append (text_label);

            indicator_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                height_request = 6
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
