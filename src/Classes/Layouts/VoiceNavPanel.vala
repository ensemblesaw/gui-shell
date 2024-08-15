/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class VoiceNavPanel : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Widgets.MIDIControllableButton piano_button;
        private Widgets.MIDIControllableButton crm_perc_button;
        private Widgets.MIDIControllableButton organ_button;
        private Widgets.MIDIControllableButton guitar_button;
        private Widgets.MIDIControllableButton bass_button;
        private Widgets.MIDIControllableButton strings_button;
        private Widgets.MIDIControllableButton brass_button;
        private Widgets.MIDIControllableButton reed_pipe_button;
        private Widgets.MIDIControllableButton synth_lead_button;
        private Widgets.MIDIControllableButton synth_pad_button;
        private Widgets.MIDIControllableButton drum_kit_button;
        private Widgets.MIDIControllableButton extra_button;

        public const string UI_URI_NAV_PIANO = "gtk.nav.piano";
        public const string UI_URI_NAV_CRM_PERC = "gtk.nav.crm-perc";
        public const string UI_URI_NAV_ORGAN = "gtk.nav.organ";
        public const string UI_URI_NAV_GUITAR = "gtk.nav.guitar";
        public const string UI_URI_NAV_BASS = "gtk.nav.bass";
        public const string UI_URI_NAV_STRINGS = "gtk.nav.strings";
        public const string UI_URI_NAV_REED_PIPES = "gtk.nav.reed-pipes";
        public const string UI_URI_NAV_BRASS = "gtk.nav.brass";
        public const string UI_URI_NAV_LEADS = "gtk.nav.leads";
        public const string UI_URI_NAV_PADS = "gtk.nav.pads";
        public const string UI_URI_NAV_DRUMS = "gtk.nav.drums";
        public const string UI_URI_NAV_EXTRAS = "gtk.nav.extras";

        construct {
            build_ui ();
        }

        private void build_ui () {
            add_css_class ("panel");
            hexpand = true;
            vexpand = true;
            width_request = 360;
            height_request = 100;
            row_homogeneous = true;
            column_homogeneous = true;
            row_spacing = 4;
            column_spacing = 4;

            var hbox = new Gtk.Box (HORIZONTAL, 8) {
                hexpand = true,
                valign = START,
                margin_bottom = 4
            };
            attach (hbox, 0, 0, 4);

            var header = new Gtk.Label (_("VOICE TYPES"));
            hbox.append (header);
            hbox.append (new Gtk.Separator (HORIZONTAL) {
                hexpand = true,
                valign = CENTER
            });

            piano_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_PIANO, _("Piano"));
            attach (piano_button, 0, 1);

            crm_perc_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_CRM_PERC, _("Crm / Perc"));
            attach (crm_perc_button, 1, 1);

            organ_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_ORGAN, _("Organ"));
            attach (organ_button, 2, 1);

            guitar_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_GUITAR, _("Guitar"));
            attach (guitar_button, 3, 1);

            bass_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_BASS, _("Bass"));
            attach (bass_button, 0, 2);

            strings_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_STRINGS, _("Strings"));
            attach (strings_button, 1, 2);

            brass_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_BRASS, _("Brass"));
            attach (brass_button, 2, 2);

            reed_pipe_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_REED_PIPES, _("Reed / Pipes"));
            attach (reed_pipe_button, 3, 2);

            synth_lead_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_LEADS, _("Synth Lead"));
            attach (synth_lead_button, 0, 3);

            synth_pad_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_PADS, _("Synth Pad"));
            attach (synth_pad_button, 1, 3);

            drum_kit_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_DRUMS, _("Drum Kit"));
            attach (drum_kit_button, 2, 3);

            extra_button = new Widgets.MIDIControllableButton.with_label (UI_URI_NAV_EXTRAS, _("Extras"));
            attach (extra_button, 3, 3);
        }
    }
}
