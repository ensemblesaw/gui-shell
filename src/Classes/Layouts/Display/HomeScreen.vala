/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.Models;
namespace Ensembles.GtkShell.Layouts.Display {
    public class HomeScreen : Adw.Bin {
        public bool kiosk_mode { get; protected set; }

        private Gtk.Overlay main_overlay;
        private Gtk.Box main_box;

        private Gtk.Box links_section;

        private Gtk.Button power_button;
        private Gtk.Button style_button;
        private Gtk.Button voice_l_button;
        private Gtk.Button voice_r1_button;
        private Gtk.Button voice_r2_button;

        private Gtk.Button dsp_button;
        private Gtk.Label dsp_status;
        private Gtk.Button recorder_button;
        private Gtk.Label recorder_status;

        private Gtk.Label selected_style_label;
        private Gtk.Label selected_voice_l_label;
        private Gtk.Label selected_voice_r1_label;
        private Gtk.Label selected_voice_r2_label;

        private Gtk.Grid status_panel;

        private Gtk.Label tempo_label;
        private Gtk.Label measure_label;
        private Gtk.Label beat_label;
        private Gtk.Label transpose_label;
        private Gtk.Label octave_label;
        private Gtk.Label chord_label;
        private Gtk.Label chord_flat_label;
        private Gtk.Label chord_type_label;

        private Gtk.Grid equalizer_grid;
        private Widgets.Display.EqualizerBar[] equalizer_bars;
        private Gtk.Button[] modulator_buttons;

        private Gtk.Stack overlay_stack;
        private ModulatorScreen mod_screen;
        private TempoScreen tempo_screen;


        private int width;
        private bool update = true;

        public signal void change_screen (string screen_name);

        public signal void tempo_increase ();
        public signal void tempo_decrease ();

        public HomeScreen (bool kiosk_mode) {
            Object (
                kiosk_mode: kiosk_mode
            );
        }

        ~HomeScreen () {
            update = false;
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            main_overlay = new Gtk.Overlay ();
            set_child (main_overlay);

            main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            main_overlay.set_child (main_box);

            main_box.add_css_class ("homescreen");
            links_section = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                height_request = 200
            };
            links_section.add_css_class ("homescreen-links-section");
            main_box.append (links_section);

            // Top Links ///////////////////////////////////////////////////////////////////////////////////////////////

            var top_link_panel = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                height_request = 56,
                hexpand = true
            };
            top_link_panel.add_css_class ("homescreen-link-panel-top");
            links_section.append (top_link_panel);

            if (kiosk_mode) {
                power_button = new Gtk.Button.from_icon_name ("system-shutdown-symbolic") {
                    height_request = 48,
                    width_request = 32
                };
                power_button.add_css_class ("homescreen-link-panel-top-button");
                top_link_panel.append (power_button);
            }

            style_button = new Gtk.Button ();
            top_link_panel.append (style_button);
            style_button.add_css_class ("homescreen-link-panel-top-button");

            var style_button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                height_request = 48,
                hexpand = true
            };
            style_button.set_child (style_button_box);

            var style_label = new Gtk.Label (_("Style")) {
                halign = Gtk.Align.CENTER
            };
            style_button_box.append (style_label);
            style_label.add_css_class ("homescreen-link-panel-top-button-header");

            selected_style_label = new Gtk.Label (_("Undefined")) {
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                halign = Gtk.Align.CENTER
            };
            style_button_box.append (selected_style_label);
            selected_style_label.add_css_class ("homescreen-link-panel-top-button-subheader");

            voice_l_button = new Gtk.Button ();
            top_link_panel.append (voice_l_button);
            voice_l_button.add_css_class ("homescreen-link-panel-top-button");

            var voice_l_button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                height_request = 48,
                hexpand = true
            };
            voice_l_button.set_child (voice_l_button_box);

            var voice_l_label = new Gtk.Label (_("Voice L")) {
                halign = Gtk.Align.CENTER
            };
            voice_l_button_box.append (voice_l_label);
            voice_l_label.add_css_class ("homescreen-link-panel-top-button-header");

            selected_voice_l_label = new Gtk.Label (_("Undefined")) {
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                halign = Gtk.Align.CENTER
            };
            voice_l_button_box.append (selected_voice_l_label);
            selected_voice_l_label.add_css_class ("homescreen-link-panel-top-button-subheader");

            voice_r1_button = new Gtk.Button ();
            top_link_panel.append (voice_r1_button);
            voice_r1_button.add_css_class ("homescreen-link-panel-top-button");

            var voice_r1_button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                height_request = 48,
                hexpand = true
            };
            voice_r1_button.set_child (voice_r1_button_box);

            var voice_r1_label = new Gtk.Label (_("Voice R1")) {
                halign = Gtk.Align.CENTER
            };
            voice_r1_button_box.append (voice_r1_label);
            voice_r1_label.add_css_class ("homescreen-link-panel-top-button-header");

            selected_voice_r1_label = new Gtk.Label (_("Undefined")) {
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                halign = Gtk.Align.CENTER
            };
            voice_r1_button_box.append (selected_voice_r1_label);
            selected_voice_r1_label.add_css_class ("homescreen-link-panel-top-button-subheader");

            voice_r2_button = new Gtk.Button ();
            top_link_panel.append (voice_r2_button);
            voice_r2_button.add_css_class ("homescreen-link-panel-top-button");

            var voice_r2_button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                height_request = 48,
                hexpand = true
            };
            voice_r2_button.set_child (voice_r2_button_box);

            var voice_r2_label = new Gtk.Label (_("Voice R2")) {
                halign = Gtk.Align.CENTER
            };
            voice_r2_button_box.append (voice_r2_label);
            voice_r2_label.add_css_class ("homescreen-link-panel-top-button-header");

            selected_voice_r2_label = new Gtk.Label (_("Undefined")) {
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                halign = Gtk.Align.CENTER
            };
            voice_r2_button_box.append (selected_voice_r2_label);
            selected_voice_r2_label.add_css_class ("homescreen-link-panel-top-button-subheader");

            // Bottom Links ////////////////////////////////////////////////////////////////////////////////////////////
            var bottom_links_panel = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                vexpand = true,
                hexpand = true,
                valign = Gtk.Align.END
            };
            links_section.append (bottom_links_panel);
            bottom_links_panel.add_css_class ("homescreen-link-panel-bottom");

            dsp_button = new Gtk.Button () {
                valign = Gtk.Align.END,
                halign = Gtk.Align.START
            };
            dsp_button.add_css_class ("homescreen-link-panel-bottom-button");
            bottom_links_panel.append (dsp_button);

            var dsp_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            dsp_button.set_child (dsp_box);

            dsp_box.append (new Gtk.Separator (Gtk.Orientation.VERTICAL));
            dsp_box.append (new Gtk.Label (_("Main DSP Rack - ")));

            dsp_status = new Gtk.Label (_("%u Effects in Use".printf (0)));
            dsp_status.add_css_class ("homescreen-link-panel-bottom-button-status");
            dsp_box.append (dsp_status);

            recorder_button = new Gtk.Button () {
                valign = Gtk.Align.END,
                halign = Gtk.Align.START
            };
            recorder_button.add_css_class ("homescreen-link-panel-bottom-button");
            bottom_links_panel.append (recorder_button);

            var recorder_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            recorder_button.set_child (recorder_box);

            recorder_box.append (new Gtk.Separator (Gtk.Orientation.VERTICAL));
            recorder_box.append (new Gtk.Label (_("Recorder - ")));

            recorder_status = new Gtk.Label (_("No Project Open"));
            recorder_status.add_css_class ("homescreen-link-panel-bottom-button-status");
            recorder_box.append (recorder_status);

            // Bottom Panel ////////////////////////////////////////////////////////////////////////////////////////////
            status_panel = new Gtk.Grid () {
                vexpand = true,
                hexpand = true,
                height_request = 150
            };
            main_box.append (status_panel);
            status_panel.add_css_class ("homescreen-panel-status");

            var tempo_header = new Gtk.Label (_("Tempo"));
            tempo_header.add_css_class ("homescreen-panel-status-header");
            status_panel.attach (tempo_header, 0, 0);

            var measure_header = new Gtk.Label (_("Measure"));
            measure_header.add_css_class ("homescreen-panel-status-header");
            status_panel.attach (measure_header, 1, 0);

            var beat_header = new Gtk.Label (_("Time Signature"));
            beat_header.add_css_class ("homescreen-panel-status-header");
            beat_header.add_css_class ("can-be-faded");
            status_panel.attach (beat_header, 2, 0);

            var transpose_header = new Gtk.Label (_("Transpose"));
            transpose_header.add_css_class ("homescreen-panel-status-header");
            transpose_header.add_css_class ("can-be-faded");
            status_panel.attach (transpose_header, 3, 0);

            var octave_header = new Gtk.Label (_("Octave"));
            octave_header.add_css_class ("homescreen-panel-status-header");
            octave_header.add_css_class ("can-be-faded");
            status_panel.attach (octave_header, 4, 0);

            var chord_header = new Gtk.Label (_("Chord"));
            chord_header.add_css_class ("homescreen-panel-status-header");
            chord_header.add_css_class ("can-be-faded");
            status_panel.attach (chord_header, 5, 0);

            var tempo_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 1) {
                halign = Gtk.Align.CENTER
            };
            status_panel.attach (tempo_box, 0, 1);

            tempo_label = new Gtk.Label ("120");
            tempo_label.add_css_class ("homescreen-panel-status-label");
            tempo_box.append (tempo_label);

            var tempo_unit_label = new Gtk.Label ("BPM") {
                margin_bottom = 8
            };
            tempo_unit_label.add_css_class ("homescreen-panel-status-label-small");
            tempo_box.append (tempo_unit_label);

            measure_label = new Gtk.Label ("0");
            measure_label.add_css_class ("homescreen-panel-status-label");
            status_panel.attach (measure_label, 1, 1);

            beat_label = new Gtk.Label ("4 / 4");
            beat_label.add_css_class ("homescreen-panel-status-label");
            beat_label.add_css_class ("can-be-faded");
            status_panel.attach (beat_label, 2, 1);

            transpose_label = new Gtk.Label ("0");
            transpose_label.add_css_class ("homescreen-panel-status-label");
            transpose_label.add_css_class ("can-be-faded");
            status_panel.attach (transpose_label, 3, 1);

            octave_label = new Gtk.Label ("0");
            octave_label.add_css_class ("homescreen-panel-status-label");
            octave_label.add_css_class ("can-be-faded");
            status_panel.attach (octave_label, 4, 1);

            var chord_grid = new Gtk.Grid () {
                halign = Gtk.Align.CENTER,
                height_request = 48,
                vexpand = true,
                valign = Gtk.Align.CENTER,
                margin_top = 5
            };
            chord_grid.add_css_class ("can-be-faded");
            status_panel.attach (chord_grid, 5, 1);

            chord_label = new Gtk.Label (_("C"));
            chord_label.add_css_class ("homescreen-panel-status-label");
            chord_grid.attach (chord_label, 0, 0, 1, 2);

            chord_flat_label = new Gtk.Label ("");
            chord_flat_label.add_css_class ("homescreen-panel-status-label-small");
            chord_grid.attach (chord_flat_label, 1, 0);

            chord_type_label = new Gtk.Label ("");
            chord_type_label.add_css_class ("homescreen-panel-status-label-small");
            chord_grid.attach (chord_type_label, 1, 1);

            equalizer_grid = new Gtk.Grid () {
                column_homogeneous = true,
                margin_start = 8,
                margin_end = 8,
                margin_bottom = 8,
                column_spacing = 4,
                row_spacing = 8,
                vexpand = true
            };
            equalizer_grid.add_css_class ("homescreen-panel-status-equalizer");
            status_panel.attach (equalizer_grid, 0, 2, 6);


            equalizer_bars = new Widgets.Display.EqualizerBar [19];
            var eq_color = get_eq_color ();

            modulator_buttons = new Gtk.Button [19];
            for (int i = 0; i < 16; i++) {
                equalizer_bars[i] = new Widgets.Display.EqualizerBar ();
                equalizer_bars[i].r = eq_color[0];
                equalizer_bars[i].g = eq_color[1];
                equalizer_bars[i].b = eq_color[2];
                equalizer_grid.attach (equalizer_bars[i], i, 0, 1, 1);

                modulator_buttons[i] = new Gtk.Button.with_label ((i + 1).to_string ());
                modulator_buttons[i].height_request = 24;
                modulator_buttons[i].add_css_class ("bolder");

                equalizer_grid.attach (modulator_buttons[i], i, 1, 1, 1);
            }

            equalizer_bars[16] = new Widgets.Display.EqualizerBar ();
            equalizer_bars[16].r = eq_color[0];
            equalizer_bars[16].g = eq_color[1];
            equalizer_bars[16].b = eq_color[2];
            equalizer_grid.attach (equalizer_bars[16], 16, 0, 1, 1);
            modulator_buttons[16] = new Gtk.Button.with_label ("L") {
                height_request = 20
            };
            modulator_buttons[16].add_css_class ("bolder");
            equalizer_grid.attach (modulator_buttons[16], 16, 1, 1, 1);

            equalizer_bars[17] = new Widgets.Display.EqualizerBar ();
            equalizer_bars[17].r = eq_color[0];
            equalizer_bars[17].g = eq_color[1];
            equalizer_bars[17].b = eq_color[2];
            equalizer_grid.attach (equalizer_bars[17], 17, 0, 1, 1);
            modulator_buttons[17] = new Gtk.Button.with_label ("R1") {
                height_request = 24
            };
            modulator_buttons[17].add_css_class ("bolder");
            equalizer_grid.attach (modulator_buttons[17], 17, 1, 1, 1);

            equalizer_bars[18] = new Widgets.Display.EqualizerBar ();
            equalizer_bars[18].r = eq_color[0];
            equalizer_bars[18].g = eq_color[1];
            equalizer_bars[18].b = eq_color[2];
            equalizer_grid.attach (equalizer_bars[18], 18, 0, 1, 1);
            modulator_buttons[18] = new Gtk.Button.with_label ("R2") {
                height_request = 24
            };
            modulator_buttons[18].add_css_class ("bolder");
            equalizer_grid.attach (modulator_buttons[18], 18, 1, 1, 1);

            overlay_stack = new Gtk.Stack () {
                can_target = false,
                margin_top = 56,
                margin_bottom = 47,
                margin_start = 8,
                margin_end = 8,
            };
            main_overlay.add_overlay (overlay_stack);

            mod_screen = new ModulatorScreen ();
            overlay_stack.add_child (mod_screen);

            tempo_screen = new TempoScreen ();
            overlay_stack.add_child (tempo_screen);
        }

        private void build_events () {
            // Similar to css media query
            add_tick_callback ((widget, frame_clock) => {
                if (width != get_width ()) {
                    width = get_width ();

                    status_panel.column_homogeneous = width > 656;
                    equalizer_grid.column_spacing = width > 656 ? 8 : 4;
                }

                return update;
            });

            style_button.clicked.connect (() => {
                change_screen ("style");
                mod_screen.close ();
                tempo_screen.close ();
                overlay_stack.can_target = false;
            });

            voice_l_button.clicked.connect (() => {
                change_screen ("voice-l");
                mod_screen.close ();
                tempo_screen.close ();
                overlay_stack.can_target = false;
            });

            voice_r1_button.clicked.connect (() => {
                change_screen ("voice-r1");
                mod_screen.close ();
                tempo_screen.close ();
                overlay_stack.can_target = false;
            });

            voice_r2_button.clicked.connect (() => {
                change_screen ("voice-r2");
                mod_screen.close ();
                tempo_screen.close ();
                overlay_stack.can_target = false;
            });

            dsp_button.clicked.connect (() => {
                change_screen ("dsp");
                tempo_screen.close ();
            });

            mod_screen.close.connect (() => {
                overlay_stack.can_target = false;
                main_box.remove_css_class ("fade-widget");
                for (uint i = 0; i < modulator_buttons.length; i++) {
                    modulator_buttons[i].remove_css_class ("accented");
                    modulator_buttons[i].opacity = 1;
                }
            });

            tempo_screen.close.connect (() => {
                overlay_stack.can_target = false;
                tempo_screen.pop_down ();
                main_box.remove_css_class ("move-aside-widget");
                status_panel.remove_css_class ("fade-widget");
            });

            tempo_screen.increase_tempo.connect (() => {
                tempo_increase ();
            });

            tempo_screen.decrease_tempo.connect (() => {
                tempo_decrease ();
            });

            modulator_buttons[0].clicked.connect (() => { open_mod_screen (0);});
            modulator_buttons[1].clicked.connect (() => { open_mod_screen (1);});
            modulator_buttons[2].clicked.connect (() => { open_mod_screen (2);});
            modulator_buttons[3].clicked.connect (() => { open_mod_screen (3);});
            modulator_buttons[4].clicked.connect (() => { open_mod_screen (4);});
            modulator_buttons[5].clicked.connect (() => { open_mod_screen (5);});
            modulator_buttons[6].clicked.connect (() => { open_mod_screen (6);});
            modulator_buttons[7].clicked.connect (() => { open_mod_screen (7);});
            modulator_buttons[8].clicked.connect (() => { open_mod_screen (8);});
            modulator_buttons[9].clicked.connect (() => { open_mod_screen (9);});
            modulator_buttons[10].clicked.connect (() => { open_mod_screen (10);});
            modulator_buttons[11].clicked.connect (() => { open_mod_screen (11);});
            modulator_buttons[12].clicked.connect (() => { open_mod_screen (12);});
            modulator_buttons[13].clicked.connect (() => { open_mod_screen (13);});
            modulator_buttons[14].clicked.connect (() => { open_mod_screen (14);});
            modulator_buttons[15].clicked.connect (() => { open_mod_screen (15);});
            modulator_buttons[16].clicked.connect (() => { open_mod_screen (16);});
            modulator_buttons[17].clicked.connect (() => { open_mod_screen (17);});
            modulator_buttons[18].clicked.connect (() => { open_mod_screen (18);});

            if (kiosk_mode) {
                power_button.clicked.connect (() => {
                    try {
                        var power_dialog = new Dialog.PowerDialog (
                            Services.di_container.obtain (Services.st_main_window)
                        );
                        power_dialog.present ();
                        power_dialog.show ();
                    } catch (Vinject.VinjectErrors e) {
                        error (e.message);
                    }
                });
            }
        }

        private void open_mod_screen (uint8 channel) {
            overlay_stack.set_visible_child (mod_screen);
            overlay_stack.can_target = true;
            if (channel == 16)
                mod_screen.pop_up (18);
            else if (channel == 17)
                mod_screen.pop_up (17);
            else if (channel == 18)
                mod_screen.pop_up (19);
            else
                mod_screen.pop_up (channel);

            for (uint i = 0; i < modulator_buttons.length; i++) {
                modulator_buttons[i].remove_css_class ("accented");
                modulator_buttons[i].opacity = 0.3;
            }

            modulator_buttons[channel].add_css_class ("accented");
            modulator_buttons[channel].opacity = 1;

            main_box.add_css_class ("fade-widget");
        }

        private float[] get_eq_color () {
            switch (Theme.theme_color) {
                case "strawberry":
                    return { 0.92f, 0.32f, 0.32f };
                case "orange":
                    return { 1, 0.63f, 0.32f };
                case "banana":
                    return { 1, 0.88f, 0.42f };
                case "lime":
                    return { 0.6f, 0.85f, 0.3f };
                case "mint":
                    return { 0.26f, 0.84f, 0.71f };
                case "blueberry":
                    return { 0.39f, 0.73f, 1 };
                case "grape":
                    return { 0.8f, 0.62f, 0.96f };
                case "bubblegum":
                    return { 0.95f, 0.4f, 0.61f };
                case "cocoa":
                    return { 0.54f, 0.44f, 0.36f };
                default:
                    return { 0.9f, 0.9f, 0.9f };
            }
        }

        public void set_style_label (string name) {
            selected_style_label.set_text (name);
        }

        public void set_voice_label (VoiceHandPosition hand_position, string name) {
            switch (hand_position) {
                case VoiceHandPosition.LEFT:
                selected_voice_l_label.set_text (name);
                break;
                case VoiceHandPosition.RIGHT:
                selected_voice_r1_label.set_text (name);
                break;
                case VoiceHandPosition.RIGHT_LAYERED:
                selected_voice_r2_label.set_text (name);
                break;
            }
        }

        public void set_dsp_count (uint16 count) {
            dsp_status.set_text (_("%u Effects in Use".printf (count)));
        }

        public void set_chord (Chord chord) {
            switch (chord.root) {
                case C:
                chord_label.set_text ("C");
                chord_flat_label.set_text ("");
                break;
                case CS:
                chord_label.set_text ("C");
                chord_flat_label.set_text ("♯");
                break;
                case D:
                chord_label.set_text ("D");
                chord_flat_label.set_text ("");
                break;
                case EF:
                chord_label.set_text ("E");
                chord_flat_label.set_text ("♭");
                break;
                case E:
                chord_label.set_text ("E");
                chord_flat_label.set_text ("");
                break;
                case F:
                chord_label.set_text ("F");
                chord_flat_label.set_text ("");
                break;
                case FS:
                chord_label.set_text ("F");
                chord_flat_label.set_text ("♯");
                break;
                case G:
                chord_label.set_text ("G");
                chord_flat_label.set_text ("");
                break;
                case AF:
                chord_label.set_text ("A");
                chord_flat_label.set_text ("♭");
                break;
                case A:
                chord_label.set_text ("A");
                chord_flat_label.set_text ("");
                break;
                case BF:
                chord_label.set_text ("B");
                chord_flat_label.set_text ("♭");
                break;
                case B:
                chord_label.set_text ("B");
                chord_flat_label.set_text ("");
                break;
                default:
                break;
            }
            switch (chord.type) {
                case MAJOR:
                chord_type_label.set_text ("");
                break;
                case MINOR:
                chord_type_label.set_text ("m");
                break;
                case DIMINISHED:
                chord_type_label.set_text ("dim");
                break;
                case SUSPENDED_2:
                chord_type_label.set_text ("sus2");
                break;
                case SUSPENDED_4:
                chord_type_label.set_text ("sus4");
                break;
                case AUGMENTED:
                chord_type_label.set_text ("aug");
                break;
                case SIXTH:
                chord_type_label.set_text ("6");
                break;
                case SEVENTH:
                chord_type_label.set_text ("7");
                break;
                case MAJOR_7TH:
                chord_type_label.set_text ("M7");
                break;
                case MINOR_7TH:
                chord_type_label.set_text ("m7");
                break;
                case ADD_9TH:
                chord_type_label.set_text ("add9");
                break;
                case NINTH:
                chord_type_label.set_text ("9");
                break;
            }
        }

        public void set_level (uint8 channel, uint8 level) {
            equalizer_bars[channel].level = level;
        }

        public void start_tempo_change () {
            if (!overlay_stack.can_target || overlay_stack.visible_child == mod_screen) {
                if (overlay_stack.visible_child == mod_screen) {
                    for (uint i = 0; i < modulator_buttons.length; i++) {
                        modulator_buttons[i].remove_css_class ("accented");
                        modulator_buttons[i].opacity = 1;
                    }

                    main_box.remove_css_class ("fade-widget");
                    mod_screen.pop_down ();
                }

                overlay_stack.set_visible_child (tempo_screen);
                overlay_stack.can_target = true;
                tempo_screen.pop_up ();
                main_box.add_css_class ("move-aside-widget");

                status_panel.add_css_class ("fade-widget");
            } else {
                tempo_screen.close ();
            }
        }

        public void set_tempo (uint8 tempo) {
            tempo_screen.set_tempo (tempo);
            tempo_label.set_text ("%u".printf (tempo));
        }

        public void set_measure (uint measure) {
            measure_label.set_text (measure.to_string ());
        }
    }
}
