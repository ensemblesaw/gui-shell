/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class SamplerPadsPanel : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Gtk.Button[] pads;
        private Gtk.Button assign_record_button;
        private Gtk.Button assign_file_button;
        private Gtk.Button stop_button;

        construct {
            build_ui ();
        }

        private void build_ui () {
            add_css_class ("panel");
            hexpand = true;
            width_request = 360;
            height_request = 100;
            column_homogeneous = true;
            row_spacing = 4;
            column_spacing = 4;

            var hbox = new Gtk.Box (HORIZONTAL, 8) {
                hexpand = true,
                valign = START,
                margin_bottom = 4
            };
            attach (hbox, 0, 0, 8);

            var header = new Gtk.Label (_("SAMPLE PADS"));
            hbox.append (header);
            hbox.append (new Gtk.Separator (HORIZONTAL) {
                hexpand = true,
                valign = CENTER
            });

            pads = new Gtk.Button [12];
            for (int i = 0; i < 6; i++) {
                pads[i] = new Gtk.Button () {
                    width_request = 24,
                    hexpand = true
                };
                pads[i].add_css_class ("sampling-pad");
                pads[i + 6] = new Gtk.Button () {
                    width_request = 24,
                    hexpand = true
                };
                pads[i + 6].add_css_class ("sampling-pad");
                attach (pads[i], i, 1);
                attach (pads[i + 6], i, 2);
            }

            assign_record_button = new Gtk.Button.from_icon_name (
                "audio-input-microphone-symbolic"
            ) {
                height_request = 38,
                hexpand = true,
                vexpand = true,
                tooltip_text = _("Click and hold to sample")
            };

            assign_record_button.add_css_class ("sampler-record-button");
            assign_record_button.remove_css_class ("image-button");
            attach (assign_record_button, 6, 1);

            assign_file_button = new Gtk.Button.from_icon_name ("document-open-symbolic") {
                height_request = 38,
                hexpand = true,
                vexpand = true
            };
            attach (assign_file_button, 6, 2);

            assign_file_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
            assign_file_button.remove_css_class ("image-button");

            stop_button = new Gtk.Button.with_label (_("Stop")) {
                width_request = 24
            };
            attach (stop_button, 7, 1, 1, 2);

        }
    }
}
