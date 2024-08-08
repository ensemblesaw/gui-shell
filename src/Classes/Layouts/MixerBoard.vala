/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class MixerBoard : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Gtk.Scale[] faders;
        private Widgets.MIDIControllableButton[] mute_buttons;

        construct {
            build_ui ();
        }

        private void build_ui () {
            add_css_class ("panel");

            height_request = 100;
            column_homogeneous = true;
            hexpand = true;
            margin_start = 8;
            margin_end = 8;

            faders = new Gtk.Scale[19];
            mute_buttons = new Widgets.MIDIControllableButton[19];

            for (uint8 i = 0; i < 19; i++) {
                var fader = new Gtk.Scale.with_range (Gtk.Orientation.VERTICAL, 0, 127, 1) {
                    vexpand = true,
                    inverted = true
                };
                attach (fader, i, 0);
                faders[i] = (owned) fader;

                var mute_button = new Widgets.MIDIControllableButton.from_icon_name (
                    "gtk.mixer_board.fader_" + (i + 1).to_string (),
                    "audio-volume-high-symbolic"
                );
                attach (mute_button, i, 1);
                mute_buttons[i] = (owned) mute_button;
            }
        }
    }
}
