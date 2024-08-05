/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.Services;
using Ensembles.ArrangerWorkstation;
using Ensembles.GtkShell.Layouts;

namespace Ensembles.GtkShell {
    public class MainWindow : Gtk.ApplicationWindow {
        private static MainWindow _instance;
        public static MainWindow instance {
            get {
                if (_instance == null) {
                    _instance = new MainWindow ();
                }

                return _instance;
            }
        }

        // Dependencies
        public unowned IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        public bool using_kiosk_layout { get; private set; }

        // Event Handling
        private Gtk.EventControllerKey event_controller_key;

        // Headerbar
        private Gtk.HeaderBar headerbar;
        Gtk.Button app_menu_button;

        // Common
        //  private ContextMenu context_menu;
        private Dialog.MIDIAssignDialog midi_assign_dialog;

        // Responsive UI
        private Adw.Squeezer squeezer;
        private Gtk.ToggleButton flap_button;
        private bool flap_revealed = true;

        // Assignable controls
        uint32 selected_route_sig;

        private MainWindow () {
        }

        public void build () {
            try {
                build_ui ();
                build_events ();
            } catch (Vinject.VinjectErrors e) {
                error (e.message);
            }
        }

        private void build_ui () throws Vinject.VinjectErrors {
            if (using_kiosk_layout) {
                decorated = false;
                fullscreened = true;

                di_container.register_singleton<InfoDisplay, ControlSurface> (
                    st_info_display,
                    aw_core: st_aw_core,
                    settings: st_settings
                );
                di_container.obtain (st_info_display).fill_screen = true;

                di_container.register_singleton<MixerBoard, ControlSurface> (
                    st_mixer_board,
                    aw_core: st_aw_core,
                    settings: st_settings
                );

                di_container.register_singleton<KioskLayout, ControlSurface> (
                    st_kiosk_layout,
                    aw_core: st_aw_core,
                    settings: st_settings,
                    info_display: st_info_display,
                    mixer_board: st_mixer_board
                );
                set_child (di_container.obtain (st_kiosk_layout));
                return;
            }

            // Make headerbar
            headerbar = new Gtk.HeaderBar () {
                show_title_buttons = true,
            };

            set_titlebar (headerbar);

            flap_button = new Gtk.ToggleButton () {
                visible = false
            };
            flap_button.set_icon_name ("view-continuous-symbolic");
            flap_button.remove_css_class ("image-button");
            flap_button.clicked.connect (() => {
                try {
                    flap_revealed = di_container.obtain (st_mobile_layout).show_menu (flap_revealed);
                } catch (Vinject.VinjectErrors e) {
                    error (e.message);
                }
            });
            headerbar.pack_start (flap_button);

            di_container.register_singleton<BeatVisualization, ControlSurface> (
                st_beat_visualization,
                aw_core: st_aw_core,
                settings: st_settings
            );
            headerbar.pack_start (di_container.obtain (st_beat_visualization));

            app_menu_button = new Gtk.Button.from_icon_name ("emblem-system");
            headerbar.pack_end (app_menu_button);

            di_container.register_singleton<AppMenu, ControlSurface> (
                st_app_menu,
                aw_core: st_aw_core,
                settings: st_settings
            );

            di_container.register_transient<ContextMenu, Gtk.Popover> (st_context_menu);

            squeezer = new Adw.Squeezer () {
                orientation = Gtk.Orientation.VERTICAL,
                transition_type = Adw.SqueezerTransitionType.CROSSFADE,
                transition_duration = 400
            };
            set_child (squeezer);

            di_container.register_singleton<AssignablesBoard, ControlSurface> (
                st_assignables_board,
                aw_core: st_aw_core,
                settings: st_settings
            );
            di_container.register_singleton<InfoDisplay, ControlSurface> (
                st_info_display,
                aw_core: st_aw_core,
                settings: st_settings
            );
            di_container.register_singleton<SynthControlPanel, ControlSurface> (
                st_synth_control_panel,
                aw_core: st_aw_core,
                settings: st_settings
            );
            di_container.register_singleton<VoiceNavPanel, ControlSurface> (
                st_voice_nav_panel,
                aw_core: st_aw_core,
                settings: st_settings
            );
            di_container.register_singleton<MixerBoard, ControlSurface> (
                st_mixer_board,
                aw_core: st_aw_core,
                settings: st_settings
            );
            di_container.register_singleton<SamplerPadsPanel, ControlSurface> (
                st_sampler_pads_panel,
                aw_core: st_aw_core,
                settings: st_settings
            );
            di_container.register_singleton<StyleControlPanel, ControlSurface> (
                st_style_control_panel,
                aw_core: st_aw_core,
                settings: st_settings,
                ui_map: st_ui_map
            );
            di_container.register_singleton<RegistryPanel, ControlSurface> (
                st_registry_panel,
                aw_core: st_aw_core,
                settings: st_settings
            );
            di_container.register_singleton<KeyboardPanel, ControlSurface> (
                st_keyboard_panel,
                aw_core: st_aw_core,
                settings: st_settings
            );
            di_container.register_singleton<JoyStick, ControlSurface> (
                st_joystick,
                aw_core: st_aw_core,
                settings: st_settings
            );

            di_container.register_singleton<DesktopLayout, ControlSurface> (
                st_desktop_layout,
                aw_core: st_aw_core,
                assignables_board: st_assignables_board,
                info_display: st_info_display,
                synth_control_panel: st_synth_control_panel,
                voice_nav_panel: st_voice_nav_panel,
                mixer_board: st_mixer_board,
                sampler_pads_panel: st_sampler_pads_panel,
                style_control_panel: st_style_control_panel,
                registry_panel: st_registry_panel,
                keyboard: st_keyboard_panel,
                joystick: st_joystick
            );

            Console.log ("hellossss");
            var _desktop_l = di_container.obtain (st_desktop_layout);
            Console.log ("hellosadaadsss");
            if (_desktop_l == null) {Console.log ("oiuhjniuhiuhiu");}
            squeezer.add (_desktop_l);
            di_container.obtain (st_desktop_layout).reparent ();

            di_container.register_singleton<MobileLayout, ControlSurface> (
                st_mobile_layout,
                aw_core: st_aw_core,
                assignables_board: st_assignables_board,
                info_display: st_info_display,
                synth_control_panel: st_synth_control_panel,
                voice_nav_panel: st_voice_nav_panel,
                mixer_board: st_mixer_board,
                sampler_pads_panel: st_sampler_pads_panel,
                style_control_panel: st_style_control_panel,
                registry_panel: st_registry_panel,
                keyboard: st_keyboard_panel,
                joystick: st_joystick
            );
            squeezer.add (di_container.obtain (st_mobile_layout));
        }

        public void show_ui () {
            present ();
            show ();
        }

        private void build_events () throws Vinject.VinjectErrors {
            app_menu_button.clicked.connect (() => {
                // For some reason the pop-over needs thes two functions to be
                // executed in this exact order to work
                var app_menu = di_container.obtain<AppMenu> (st_app_menu);
                if (app_menu.parent == null) {
                    app_menu.set_parent (app_menu_button);
                }

                app_menu.show ();
                app_menu.present ();
            });

            event_controller_key = new Gtk.EventControllerKey ();
            ((Gtk.Widget)this).add_controller (event_controller_key);

            event_controller_key.key_pressed.connect ((keyval, keycode, state) => {
                Console.log ("key: %u".printf (keyval));

                return false;
            });

            aw_core.ready.connect (() => {
                Console.log ("Arranger Workstation Initialized!", Console.LogLevel.SUCCESS);
                load_settings ();
            });

            notify["default-height"].connect (() => {
                try {
                    var mobile_layout = di_container.obtain (st_mobile_layout);
                    var desktop_layout = di_container.obtain (st_desktop_layout);

                    if (!using_kiosk_layout) {
                        flap_button.visible = squeezer.get_visible_child () == mobile_layout;

                        if (squeezer.get_visible_child () == desktop_layout) {
                            desktop_layout.reparent ();
                        } else {
                            mobile_layout.reparent ();
                            desktop_layout.active = false;
                        }
                    }
                } catch (Vinject.VinjectErrors e) {
                    error (e.message);
                }
            });

            notify["maximized"].connect (() => {
                //  fullscreen ();
                try {
                    var mobile_layout = di_container.obtain (st_mobile_layout);
                    var desktop_layout = di_container.obtain (st_desktop_layout);

                    Timeout.add (100, () => {
                        if (!using_kiosk_layout) {
                            flap_button.visible = squeezer.get_visible_child () == mobile_layout;

                            if (squeezer.get_visible_child () == desktop_layout) {
                                desktop_layout.reparent ();
                            } else {
                                mobile_layout.reparent ();
                            }
                        }
                        return false;
                    });
                } catch (Vinject.VinjectErrors e) {
                    error (e.message);
                }
            });

            di_container.obtain (st_mobile_layout).on_menu_show_change.connect ((shown) => {
                flap_revealed = !shown;
                flap_button.active = shown;
            });

            ((Gtk.Widget) this).realize.connect (() => {
                if (using_kiosk_layout) {
                    var display = Gdk.Display.get_default ();
                    var monitor = display.get_monitor_at_surface (get_surface ());
                    set_default_size (monitor.geometry.width, monitor.geometry.height);

                    try {
                        var kiosk_layout = di_container.obtain (st_kiosk_layout);
                        kiosk_layout.width_request = monitor.geometry.width;
                        kiosk_layout.height_request = monitor.geometry.height;
                    } catch (Vinject.VinjectErrors e) {
                        error (e.message);
                    }
                }
            });

            di_container.obtain (st_style_control_panel).context_menu.connect ((widget) => {
                show_context_menu (widget);
            });

            di_container.obtain (st_beat_visualization).start_tempo_change.connect (() => {
                try {
                    di_container.obtain (st_info_display).start_tempo_change ();
                } catch (Error e) {

                }
            });
        }

        private void load_settings () {
            var device_channel_map = settings.midi_input_channel_map;
            for (uint8 i = 0; i < device_channel_map.length && i < 16; i++) {
                var map = device_channel_map[i].split (",", 2);
                var dev_channel = (uint8) int.parse (map[0]);
                var dest_channel = (uint8) int.parse (map[1]);
                aw_core.map_device_channel (dev_channel, dest_channel);
            }
        }

        public void show_context_menu (MIDIControllable midi_controllable_widget) {
            var common_context_menu = di_container.obtain (st_context_menu);
            common_context_menu.set_parent (midi_controllable_widget);
            common_context_menu.control_uri = midi_controllable_widget.uri;
            common_context_menu.assign.connect ((_route) => {
                midi_assign_dialog = new Dialog.MIDIAssignDialog (this, _route);
                midi_assign_dialog.present ();
                common_context_menu.hide ();
                aw_core.configure_midi_device.connect (configure_controller_handler);
                midi_assign_dialog.close.connect (() => {
                    midi_assign_dialog.destroy ();
                    aw_core.configure_midi_device.disconnect (configure_controller_handler);
                });
                midi_assign_dialog.assigned.connect ((control_uri) => {
                    var control_route = di_container.obtain (Services.st_ui_map).map_uri (control_uri);
                    aw_core.map_cc_from_midi_device (selected_route_sig, control_route);
                });
            });
            common_context_menu.assignment_label = "";
            common_context_menu.show ();
            common_context_menu.present ();
        }

        // Route signature is formed by combining type, channel and data
        // rest of the parameters are for display only
        private bool configure_controller_handler (uint32 route_sig, uint8 type, uint8 channel, uint8 data) {
            selected_route_sig = route_sig;
            midi_assign_dialog.set_configuration_details (type, channel, data);
            return true;
        }

        public void hide_context_menu () {
            //  common_context_menu.hide ();
        }
    }
 }
