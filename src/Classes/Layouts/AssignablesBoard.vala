/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class AssignablesBoard : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Gtk.Scale[] faders;
        private Widgets.Knob[] knobs;
        private Widgets.MasterKnob master_knob;

        construct {
            build_ui ();
        }

        private void build_ui () {
            add_css_class ("panel");
            hexpand = true;
            vexpand = true;
            width_request = 360;
            height_request = 300;


            knobs = new Widgets.Knob[4];

            var knob_grid = new Gtk.Grid () {
                hexpand = true,
                column_homogeneous = true,
                margin_top = 22,
                margin_bottom = 18,
                row_spacing = 2
            };
            attach (knob_grid, 0, 0);

            for (uint8 i = 0; i < 4; i++) {
                var knob = new Widgets.Knob.with_range (0, 127, 1) {
                    name = "knob-%u".printf (i),
                    width_request = 40,
                    height_request = 40,
                    halign = Gtk.Align.CENTER,
                    valign = Gtk.Align.START,
                    meter_padding = 2,
                    draw_dot = true
                };
                knob.add_css_class ("small");
                knob.add_css_class ("opaque");
                knob_grid.attach (knob, i, 0);
                knob_grid.attach (new Gtk.Label ((i + 1).to_string ()) { opacity = 0.6 }, i, 1);
                knobs[i] = (owned) knob;
            }

            master_knob = new Widgets.MasterKnob ();
            knob_grid.attach (master_knob, 4, 0, 1, 2);


            faders = new Gtk.Scale[10];

            var fader_grid = new Gtk.Grid () {
                hexpand = true,
                vexpand = true,
                column_homogeneous = true
            };
            attach (fader_grid, 0, 1);

            for (uint8 i = 0; i < 10; i++) {
                var fader = new Gtk.Scale.with_range (Gtk.Orientation.VERTICAL, 0, 127, 1) {
                    inverted = true,
                    vexpand = true,
                    name = "fader-%u".printf (i),
                };

                fader_grid.attach (fader, i, 0);
                fader_grid.attach (new Gtk.Label ((i + 1).to_string ()) { opacity = 0.6 }, i, 1);

                faders[i] = (owned) fader;
            }

        }
    }
}
