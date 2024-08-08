/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.GtkShell.Layouts.Display;

namespace Ensembles.GtkShell.Layouts {
    public class InfoDisplay : Gtk.Box, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Gtk.Overlay main_overlay;
        private Gtk.Box splash_screen;
        private Gtk.Label splash_screen_label;
        private Gtk.Stack main_stack;

        private bool _fill_screen;
        public bool fill_screen {
            get {
                return _fill_screen;
            }
            set {
                _fill_screen = value;
                if (value) {
                    remove_css_class ("panel");
                    main_overlay.add_css_class ("fill");
                } else {
                    add_css_class ("panel");
                    main_overlay.remove_css_class ("fill");
                }
            }
        }

        public bool kiosk_mode { get; construct; }

        // Screens
        private HomeScreen home_screen;
        private StyleScreen style_screen;
        private VoiceScreen voice_l_screen;
        private VoiceScreen voice_r1_screen;
        private VoiceScreen voice_r2_screen;
        private DSPScreen dsp_screen;
        private PluginScreen plugin_screen;

        construct {
            build_ui ();
            build_events ();
            update_equalizer.begin ();
        }

        private void build_ui () {
            hexpand = true;
            vexpand = true;
            width_request = 532;
            height_request = 300;

            add_css_class ("panel");

            main_overlay = new Gtk.Overlay () {
                hexpand = true,
                vexpand = true,
                overflow = Gtk.Overflow.HIDDEN
            };
            main_overlay.add_css_class ("display");
            append (main_overlay);

            splash_screen = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            splash_screen.add_css_class ("splash-screen-background");
            main_overlay.add_overlay (splash_screen);

            var splash_banner = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                vexpand = true
            };
            splash_banner.add_css_class ("ensembles-logo-splash");
            splash_screen.append (splash_banner);

            splash_screen_label = new Gtk.Label (_("Initializing…")) {
                xalign = 0,
                margin_start = 8,
                margin_bottom = 8,
                margin_end = 8,
                margin_top = 8,
                opacity = 0.5
            };
            splash_screen_label.add_css_class ("splash-screen-label");
            splash_screen.append (splash_screen_label);

            main_stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.OVER_UP_DOWN
            };
            main_stack.add_css_class ("display-stack");
            main_stack.add_css_class ("fade-black");
            main_overlay.set_child (main_stack);

            home_screen = new HomeScreen (kiosk_mode);
            main_stack.add_named (home_screen, "home");

            style_screen = new StyleScreen ();
            main_stack.add_named (style_screen, "style");

            voice_l_screen = new VoiceScreen (Ensembles.VoiceHandPosition.LEFT);
            main_stack.add_named (voice_l_screen, "voice-l");

            voice_r1_screen = new VoiceScreen (Ensembles.VoiceHandPosition.RIGHT);
            main_stack.add_named (voice_r1_screen, "voice-r1");

            voice_r2_screen = new VoiceScreen (Ensembles.VoiceHandPosition.RIGHT_LAYERED);
            main_stack.add_named (voice_r2_screen, "voice-r2");
        }

        private void build_events () {
            aw_core.ready.connect (() => {
                splash_screen.add_css_class ("fade-black");

                Timeout.add (1000, () => {
                    main_overlay.remove_overlay (splash_screen);
                    if (splash_screen != null) {
                        splash_screen.unref ();
                    }

                    Timeout.add (200, () => {
                        main_stack.remove_css_class ("fade-black");
                        return false;
                    });

                    Timeout.add (400, () => {
                        Console.log ("Populating all dsp effects");
                        dsp_screen = new DSPScreen (aw_core.get_main_dsp_rack (), aw_core);
                        dsp_screen.close.connect (navigate_to_home);
                        dsp_screen.ui_activate.connect (show_plugin_screen);
                        dsp_screen.on_plugin_active_change.connect ((count) => {
                            home_screen.set_dsp_count (count);
                        });
                        main_stack.add_named (dsp_screen, "dsp");
                        return false;
                    });
                    return false;
                });

                Timeout.add (100, () => {
                    voice_l_screen.populate (aw_core.get_voices ());
                    voice_r1_screen.populate (aw_core.get_voices ());
                    voice_r1_screen.populate_plugins (
                        aw_core.get_voice_rack (VoiceHandPosition.RIGHT).get_plugins ()
                    );
                    voice_r2_screen.populate (aw_core.get_voices ());
                    return false;
                });
            });

            home_screen.change_screen.connect ((screen_name) => {
                main_stack.set_visible_child_name (screen_name);
            });

            aw_core.send_loading_status.connect (update_status);

            aw_core.chord_changed.connect ((chord) => {
                home_screen.set_chord (chord);
            });

            aw_core.on_tempo_change.connect ((tempo) => {
                home_screen.set_tempo (tempo);
            });

            aw_core.beat.connect ((is_measure, measure) => {
                home_screen.set_measure (measure);
            });

            aw_core.beat_reset.connect (() => {
                home_screen.set_measure (0);
            });

            home_screen.tempo_increase.connect (() => {
                aw_core.style_engine_set_tempo (aw_core.style_engine_get_tempo () + 1);
            });

            home_screen.tempo_decrease.connect (() => {
                aw_core.style_engine_set_tempo (aw_core.style_engine_get_tempo () - 1);
            });

            style_screen.style_changed.connect ((style) => {
                home_screen.set_style_label (style.name);
                aw_core.style_engine_queue_style (style, settings.autofill);
            });

            voice_r1_screen.on_voice_chosen.connect ((is_plugin, name, bank, preset, index) => {
                choose_voice (VoiceHandPosition.RIGHT, is_plugin, name, bank, preset, index);
            });

            voice_r2_screen.on_voice_chosen.connect ((is_plugin, name, bank, preset, index) => {
                choose_voice (VoiceHandPosition.RIGHT_LAYERED, is_plugin, name, bank, preset, index);
            });

            voice_l_screen.on_voice_chosen.connect ((is_plugin, name, bank, preset, index) => {
                choose_voice (VoiceHandPosition.LEFT, is_plugin, name, bank, preset, index);
            });

            style_screen.close.connect (navigate_to_home);
            voice_l_screen.close.connect (navigate_to_home);
            voice_r1_screen.close.connect (navigate_to_home);
            voice_r2_screen.close.connect (navigate_to_home);
        }

        private void choose_voice (
            VoiceHandPosition position,
            bool is_plugin,
            string name,
            uint8 bank,
            uint8 preset,
            int index
        ) {
            if (is_plugin) {
                aw_core.get_voice_rack (position).active = true;
                aw_core.get_voice_rack (position)
                .set_plugin_active (index, true);
            } else {
                aw_core.get_voice_rack (position).active = false;
                aw_core.set_voice (position, bank, preset);
            }

            home_screen.set_voice_label (position, name);
        }

        public void navigate_to_home () {
            main_stack.set_visible_child_name ("home");
        }

        public void show_plugin_screen (ArrangerWorkstation.Plugins.AudioPlugins.AudioPlugin plugin) {
            if (plugin_screen != null) {
                main_stack.remove (plugin_screen);
                plugin_screen = null;
            }

            plugin_screen = new PluginScreen (plugin) {
                history = main_stack.get_visible_child_name ()
            };
            plugin_screen.close.connect (() => {
                main_stack.set_visible_child_name (plugin_screen.history);
            });
            main_stack.add_named (plugin_screen, "plugin");
            main_stack.set_visible_child_name ("plugin");
        }

        public void update_status (string status) {
            Idle.add (() => {
                splash_screen_label.set_text (status);
                return false;
            });
        }

        public void start_tempo_change () {
            home_screen.start_tempo_change ();
        }

        private async void update_equalizer () {
            Timeout.add (60000 / (120 * 16), () => {
                if (aw_core.style_engine_is_playing ()) {
                    // Style channels
                    for (uint8 i = 0; i < 16; i++) {
                        home_screen.set_level (i, aw_core.get_velocity (i));
                    }
                }

                //  equalizer_bar[17].velocity = aw_core.get_velocity (17); // R1
                //  equalizer_bar[18].velocity = aw_core.get_velocity (18); // R2
                //  equalizer_bar[16].velocity = aw_core.get_velocity (19); // L
                return true;
            });
        }
    }
}
