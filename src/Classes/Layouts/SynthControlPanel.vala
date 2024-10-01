/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class SynthControlPanel : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Widgets.ScrollDial scroll_dial;
        private Widgets.MIDIControllableButton auto_voice_a_button;
        private Widgets.MIDIControllableButton auto_voice_b_button;
        private Widgets.MIDIControllableButton auto_voice_c_button;
        private Widgets.MIDIControllableButton auto_voice_d_button;
        private Widgets.ToggleButton chords_button;
        private Widgets.ToggleButton metronome_button;
        private Widgets.ToggleButton layer_button;
        private Widgets.ToggleButton split_button;
        private Widgets.ToggleButton transpose_button;
        private Widgets.MIDIControllableSpinButton transpose_spin_button;
        private Widgets.ToggleButton octave_button;
        private Widgets.MIDIControllableSpinButton octave_spin_button;
        private Widgets.ToggleButton reverb_button;
        private Widgets.MIDIControllableSpinButton reverb_spin_button;
        private Widgets.ToggleButton chorus_button;
        private Widgets.MIDIControllableSpinButton chorus_spin_button;
        private Widgets.ToggleButton arpeggiator_button;
        private Widgets.MIDIControllableSpinButton arpeggiator_spin_button;
        private Widgets.ToggleButton harmonizer_button;
        private Widgets.MIDIControllableSpinButton harmonizer_spin_button;

        // URIs
        public const string UI_URI_SCROLL_DIAL = "gtk.synthcpl.scroll_dial";
        public const string UI_URI_CHORDS_BTN = "gtk.synthspl.chords_btn";
        public const string UI_URI_METRONOME_BTN = "gtk.synthcpl.metronome_btn";
        public const string UI_URI_LAYER_BTN = "gtk.synthcpl.layer_btn";
        public const string UI_URI_SPLIT_BTN = "gtk.synthcpl.split_btn";
        public const string UI_URI_REVERB_BTN = "gtk.synthcpl.reverb_btn";
        public const string UI_URI_REVERB_SPIN = "gtk.synthcpl.reverb_spin";
        public const string UI_URI_CHORUS_BTN = "gtk.synthcpl.chorus_btn";
        public const string UI_URI_CHORUS_SPIN = "gtk.synthcpl.chorus_spin";
        public const string UI_URI_TRANSPOSE_BTN = "gtk.synthcpl.transpose_btn";
        public const string UI_URI_TRANSPOSE_SPIN = "gtk.synthcpl.transpose_spin";
        public const string UI_URI_OCTAVE_BTN = "gtk.synthcpl.octave_btn";
        public const string UI_URI_OCTAVE_SPIN = "gtk.synthcpl.octave_spin";
        public const string UI_URI_ARPEGGIATOR_BTN = "gtk.synthcpl.arpp_btn";
        public const string UI_URI_ARPEGGIATOR_SPIN= "gtk.synthcpl.arpp_spin";
        public const string UI_URI_HARMONIZER_BTN = "gtk.synthcpl.harmo_btn";
        public const string UI_URI_HARMONIZER_SPIN = "gtk.synthcpl.harmo_spin";
        public const string UI_URI_AUTO_VOICE_BTN_A = "gtk.synthcpl.autovoice_a";
        public const string UI_URI_AUTO_VOICE_BTN_B = "gtk.synthcpl.autovoice_b";
        public const string UI_URI_AUTO_VOICE_BTN_C = "gtk.synthcpl.autovoice_c";
        public const string UI_URI_AUTO_VOICE_BTN_D = "gtk.synthcpl.autovoice_d";

        construct {
            build_ui ();
            build_events ();
        }

        ~SynthControlPanel() {
            aw_core.on_synth_render.disconnect (animate_audio);
        }

        private void build_ui () {
            add_css_class ("panel");
            hexpand = true;
            vexpand = true;
            width_request = 360;
            height_request = 300;
            row_homogeneous = true;
            column_homogeneous = true;
            row_spacing = 4;
            column_spacing = 4;

            scroll_dial = new Widgets.ScrollDial (UI_URI_SCROLL_DIAL) {
                width_request = 80,
                height_request = 80,
                margin_top = 8,
                margin_start = 12,
                margin_end = 14,
                margin_bottom = 12,
                valign = Gtk.Align.START
            };
            attach (scroll_dial, 0, 0, 1, 4);

            chords_button = new Widgets.ToggleButton (UI_URI_CHORDS_BTN,_("Chords"));
            attach (chords_button, 2, 0);

            metronome_button = new Widgets.ToggleButton (UI_URI_METRONOME_BTN,_("Metronome"));
            attach (metronome_button, 2, 1);

            layer_button = new Widgets.ToggleButton (UI_URI_LAYER_BTN,"Layer");
            attach (layer_button, 2, 2);

            split_button = new Widgets.ToggleButton (UI_URI_SPLIT_BTN,_("Split"));
            attach (split_button, 2, 3);

            var auto_voice_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                homogeneous = true
            };
            auto_voice_box.add_css_class (Granite.STYLE_CLASS_LINKED);
            attach (auto_voice_box, 0, 4, 1, 4);

            auto_voice_a_button = new Widgets.MIDIControllableButton.with_label (UI_URI_AUTO_VOICE_BTN_A, _("Auto Voice A"));
            auto_voice_box.append (auto_voice_a_button);

            auto_voice_b_button = new Widgets.MIDIControllableButton.with_label (UI_URI_AUTO_VOICE_BTN_B, _("Auto Voice B"));
            auto_voice_box.append (auto_voice_b_button);

            auto_voice_c_button = new Widgets.MIDIControllableButton.with_label (UI_URI_AUTO_VOICE_BTN_C, _("Auto Voice C"));
            auto_voice_box.append (auto_voice_c_button);

            auto_voice_d_button = new Widgets.MIDIControllableButton.with_label (UI_URI_AUTO_VOICE_BTN_D, _("Auto Voice D"));
            auto_voice_box.append (auto_voice_d_button);

            reverb_button = new Widgets.ToggleButton (UI_URI_REVERB_BTN, _("Reverb"));
            attach (reverb_button, 1, 0);

            reverb_spin_button = new Widgets.MIDIControllableSpinButton.with_range (UI_URI_REVERB_SPIN, 1, 10, 1, 1);
            attach (reverb_spin_button, 1, 1);

            chorus_button = new Widgets.ToggleButton (UI_URI_CHORUS_BTN, _("Chorus"));
            attach (chorus_button, 1, 2);

            chorus_spin_button = new Widgets.MIDIControllableSpinButton.with_range (UI_URI_CHORUS_SPIN, 1, 10, 1, 1);
            attach (chorus_spin_button, 1, 3);

            transpose_button = new Widgets.ToggleButton (UI_URI_TRANSPOSE_BTN, _("Transpose"));
            attach (transpose_button, 1, 4);

            transpose_spin_button = new Widgets.MIDIControllableSpinButton.with_range (UI_URI_TRANSPOSE_SPIN, -11, 11, 1, 0);
            attach (transpose_spin_button, 1, 5);

            octave_button = new Widgets.ToggleButton (UI_URI_OCTAVE_BTN, _("Octave"));
            attach (octave_button, 1, 6);

            octave_spin_button = new Widgets.MIDIControllableSpinButton.with_range (UI_URI_OCTAVE_SPIN, -2, 2, 1, 0);
            attach (octave_spin_button, 1, 7);

            arpeggiator_button = new Widgets.ToggleButton (UI_URI_ARPEGGIATOR_BTN, _("Arpeggiator"));
            attach (arpeggiator_button, 2, 4);

            arpeggiator_spin_button = new Widgets.MIDIControllableSpinButton.with_range (UI_URI_ARPEGGIATOR_SPIN, 1, 10, 1, 1);
            attach (arpeggiator_spin_button, 2, 5);

            harmonizer_button = new Widgets.ToggleButton (UI_URI_HARMONIZER_BTN, _("Haromonizer"));
            attach (harmonizer_button, 2, 6);

            harmonizer_spin_button = new Widgets.MIDIControllableSpinButton.with_range (UI_URI_HARMONIZER_SPIN, 1, 9, 1, 1);
            attach (harmonizer_spin_button, 2, 7);
        }

        private void build_events () {
            aw_core.on_synth_render.connect (animate_audio);
        }

        public void animate_audio (float* buffer_l, float* buffer_r, int len) {
            if (scroll_dial != null) {
                scroll_dial.animate_audio (buffer_l, buffer_r, len);
            }
        }
    }
}
