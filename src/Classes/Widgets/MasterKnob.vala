/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.ArrangerWorkstation;
namespace Ensembles.GtkShell.Widgets {
    public class MasterKnob : Knob {
        public MasterKnob () {
            Object (
                meter_padding: 2,
                value: 0
            );

            adjustment.lower = 0;
            adjustment.upper = 127;
            adjustment.step_increment = 1;
        }

        private Gtk.Box secondary_knob_cover;
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

            build_events ();
        }

        private void build_ui () {
            add_css_class ("opaque");
            hexpand = true;
            width_request = 64;
            margin_bottom = 18;
            margin_top = 18;
            knob_cover.add_css_class ("master-knob-cover");
            draw_dot = true;
            dot_offset = 0.3;

            secondary_knob_cover = new Gtk.Box (VERTICAL, 0) {
                hexpand = true,
                vexpand = true
            };
            knob_cover.append (secondary_knob_cover);

            secondary_knob_cover.add_css_class ("secondary-knob-cover");
        }

        private void build_events () {
            width_changed.connect ((width) => {
                secondary_knob_cover.margin_start = (int) width / 5;
                secondary_knob_cover.margin_end = (int) width / 5;
                secondary_knob_cover.margin_top = (int) width / 5;
                secondary_knob_cover.margin_bottom = (int) width / 5;
            });
        }
    }
}
