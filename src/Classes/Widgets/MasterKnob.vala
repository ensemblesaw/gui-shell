/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.ArrangerWorkstation;
namespace Ensembles.GtkShell.Widgets {
    public class MasterKnob : Knob {
        public MasterKnob () {
            Object (
                width_request: 64,
                height_request: 64,
                halign: Gtk.Align.CENTER,
                meter_padding: 2,
                value: 0
            );

            adjustment.lower = 0;
            adjustment.upper = 127;
            adjustment.step_increment = 1;
        }

        private bool ui_built = false;

        construct {
            realize.connect (() => {
                Idle.add (() => {
                    if (!ui_built) {
                        ui_built = true;
                        build_ui ();
                    }
                    return false;
                });
            });
        }

        private void build_ui () {
            add_css_class ("opaque");
            knob_cover.add_css_class ("master-knob-cover");
            draw_dot = true;
            dot_offset = 0.3;

            var secondary_knob_cover = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                hexpand = true,
                vexpand = true
            };
            knob_cover.append (secondary_knob_cover);

            secondary_knob_cover.add_css_class ("secondary-knob-cover");
        }
    }
}
