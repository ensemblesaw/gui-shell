/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class SynthControlPanel : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Widgets.ScrollDial scroll_dial;
        private Gtk.Button one_touch_button;
        private Widgets.MIDIControllableButton style_auto_sync_button;
        private Widgets.ToggleButton chords_button;
        private Widgets.ToggleButton metronome_button;
        private Widgets.ToggleButton layer_button;
        private Widgets.ToggleButton split_button;
        private Widgets.ToggleButton transpose_button;
        private Gtk.SpinButton transpose_spin_button;
        private Widgets.ToggleButton octave_button;
        private Gtk.SpinButton octave_spin_button;
        private Widgets.ToggleButton reverb_button;
        private Gtk.SpinButton reverb_spin_button;
        private Widgets.ToggleButton chorus_button;
        private Gtk.SpinButton chorus_spin_button;
        private Widgets.ToggleButton arpeggiator_button;
        private Gtk.SpinButton arpeggiator_spin_button;
        private Widgets.ToggleButton harmonizer_button;
        private Gtk.SpinButton harmonizer_spin_button;

        construct {
            build_ui ();
            build_events ();
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

            scroll_dial = new Widgets.ScrollDial ("") {
                width_request = 80,
                height_request = 80,
                margin_top = 8,
                margin_start = 12,
                margin_end = 14,
                margin_bottom = 12,
                valign = Gtk.Align.START
            };
            attach (scroll_dial, 0, 0, 1, 4);

            chords_button = new Widgets.ToggleButton ("",_("Chords"));
            attach (chords_button, 2, 0);

            metronome_button = new Widgets.ToggleButton ("",_("Metronome"));
            attach (metronome_button, 2, 1);

            layer_button = new Widgets.ToggleButton ("","Layer");
            attach (layer_button, 2, 2);

            split_button = new Widgets.ToggleButton ("",_("Split"));
            attach (split_button, 2, 3);

            one_touch_button = new Gtk.Button.with_label (_("Auto Voice"));
            attach (one_touch_button, 0, 4, 1, 2);

            style_auto_sync_button = new Widgets.MIDIControllableButton.with_label ("", _("Sync Rhythm"));
            attach (style_auto_sync_button, 0, 6, 1, 2);

            reverb_button = new Widgets.ToggleButton ("", _("Reverb"));
            attach (reverb_button, 1, 0);

            reverb_spin_button = new Gtk.SpinButton.with_range (1, 10, 1);
            attach (reverb_spin_button, 1, 1);

            chorus_button = new Widgets.ToggleButton ("", _("Chorus"));
            attach (chorus_button, 1, 2);

            chorus_spin_button = new Gtk.SpinButton.with_range (1, 10, 1);
            attach (chorus_spin_button, 1, 3);

            transpose_button = new Widgets.ToggleButton ("", _("Transpose"));
            attach (transpose_button, 1, 4);

            transpose_spin_button = new Gtk.SpinButton.with_range (-11, 11, 1);
            attach (transpose_spin_button, 1, 5);

            octave_button = new Widgets.ToggleButton ("", _("Octave"));
            attach (octave_button, 1, 6);

            octave_spin_button = new Gtk.SpinButton.with_range (-2, 2, 1);
            attach (octave_spin_button, 1, 7);

            arpeggiator_button = new Widgets.ToggleButton ("", _("Arpeggiator"));
            attach (arpeggiator_button, 2, 4);

            arpeggiator_spin_button = new Gtk.SpinButton.with_range (1, 10, 1);
            attach (arpeggiator_spin_button, 2, 5);

            harmonizer_button = new Widgets.ToggleButton ("", _("Haromonizer"));
            attach (harmonizer_button, 2, 6);

            harmonizer_spin_button = new Gtk.SpinButton.with_range (1, 9, 1);
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
