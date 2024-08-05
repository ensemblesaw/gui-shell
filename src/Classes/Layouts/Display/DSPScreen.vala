/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.GtkShell.Widgets.Display;
using Ensembles.Models;
using Ensembles.ArrangerWorkstation;
using Ensembles.ArrangerWorkstation.Plugins.AudioPlugins;
using Ensembles.ArrangerWorkstation.Racks;

namespace Ensembles.GtkShell.Layouts.Display {
    public class DSPScreen : DisplayWindow {

        private Gtk.Button plugin_picker_button;
        private Gtk.Switch dsp_switch;
        private Adw.Flap main_flap;
        private Gtk.ListBox main_list_box;
        private AudioPluginPicker plugin_picker;

        private unowned DSPRack rack;
        private unowned IAWCore aw_core;

        public signal void ui_activate (AudioPlugin plugin);
        public signal void on_plugin_active_change (uint16 n);

        public DSPScreen (DSPRack rack, IAWCore aw_core) {
            base (_("Main DSP Rack"), _("Add Effects to the Rack to apply them globally"));

            this.rack = rack;
            this.aw_core = aw_core;

            build_ui ();
            build_events ();
        }

        private void build_ui () {
            dsp_switch = new Gtk.Switch () {
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.CENTER
            };
            dsp_switch.active = true;
            add_to_header (dsp_switch);

            plugin_picker_button = new Gtk.Button.from_icon_name ("plugin-add-symbolic") {
                width_request = 36,
                tooltip_text = _("Add plugin to DSP Rack")
            };
            add_to_header (plugin_picker_button);

            main_flap = new Adw.Flap () {
                fold_policy = Adw.FlapFoldPolicy.ALWAYS,
                flap_position = Gtk.PackType.END
            };
            main_flap.add_css_class ("plugin-flap");
            append (main_flap);

            plugin_picker = new AudioPluginPicker (AudioPlugin.Category.DSP);
            plugin_picker.populate (aw_core.get_audio_plugins ());
            main_flap.set_flap (plugin_picker);

            var scrollable = new Gtk.ScrolledWindow () {
                hexpand = true,
                vexpand = true,
                margin_start = 8,
                margin_end = 8,
                margin_top = 8,
                margin_bottom = 8
            };
            scrollable.add_css_class ("can-be-blurred");
            main_flap.set_content (scrollable);

            main_list_box = new Gtk.ListBox () {
                selection_mode = Gtk.SelectionMode.NONE
            };
            main_list_box.add_css_class ("menu-box");
            scrollable.set_child (main_list_box);
        }

        private void build_events () {
            dsp_switch.notify["active"].connect (() => {
                rack.active = dsp_switch.active;
            });

            plugin_picker_button.clicked.connect (() => {
                main_flap.reveal_flap = !main_flap.reveal_flap;
            });

            plugin_picker.plugin_picked.connect ((plugin) => {
                try {
                    rack.append (plugin.duplicate ());
                } catch (PluginError e) {
                    Console.log ("Failed to add plugin %s with error %s".printf (plugin.name, e.message),
                    Console.LogLevel.WARNING);
                }
            });

            main_flap.notify.connect ((param) => {
                if (param.name == "reveal-flap") {
                    Idle.add (() => {
                        if (main_flap.reveal_flap) {
                            main_flap.get_content ().add_css_class ("blurred");
                        } else {
                            main_flap.get_content ().remove_css_class ("blurred");
                        }

                        return false;
                    });
                }
            });

            //  aw_core.rack_reconnected.connect ((rack, change_index) => {
            //      if (rack.rack_type == AudioPlugin.Category.DSP) {
            //          populate (rack.get_plugins (), change_index);
            //      }

            //      main_flap.reveal_flap = false;
            //  });

            rack.on_plugin_connect.connect ((change_index) => {
                populate (rack.get_plugins (), change_index);
            });
        }

        public void populate (List<AudioPlugin> plugins, int highlight_index) {
            while (main_list_box.get_first_child () != null) {
                main_list_box.remove (main_list_box.get_first_child ());
            }

            for (uint16 i = 0; i < plugins.length (); i++) {
                var menu_item = new DSPInstanceMenuItem (plugins.nth_data (i), this);
                main_list_box.insert (menu_item, -1);

                if (highlight_index == i) {
                    menu_item.capture_attention ();
                }

                menu_item.ui_activate.connect (show_plugin_ui);
                plugins.nth_data (i).notify["active"].connect (() => {
                    handle_plugin_activate ();
                });
            }

            min_value = 0;
            max_value = (int) plugins.length () - 1;
        }

        public void delete_plugin_item (DSPInstanceMenuItem item) {
            unowned AudioPlugin plugin = item.plugin;
            main_list_box.remove (item);
            rack.remove_data (plugin);
        }

        private void show_plugin_ui (AudioPlugin plugin) {
            ui_activate (plugin);
        }

        private void handle_plugin_activate () {
            unowned List<AudioPlugin> plugins = rack.get_plugins ();
            uint16 count = 0;
            plugins.foreach ((plugin) => {
                if (plugin.active) {
                    count++;
                }
            });

            on_plugin_active_change (count);
        }
    }
}
