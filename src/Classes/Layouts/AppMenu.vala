/*
 * Copyright 2020-2022 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.ArrangerWorkstation;

namespace Ensembles.GtkShell {
    /**
     * The menu that opens when you click the "gear" icon
     */
    public class AppMenu : Gtk.Popover, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Gtk.ToggleButton audio_input_mic;
        private Gtk.ToggleButton audio_input_system;
        private Gtk.ToggleButton audio_input_both;
        private Gtk.SpinButton song_channel_spin_button;
        private Granite.SwitchModelButton auto_fill_item;
        private Granite.SwitchModelButton device_input_item;
        private Gtk.Revealer revealer;
        private Gtk.ListBox device_list_box;
        private List<DeviceItem> device_items;
        private Granite.SwitchModelButton midi_split_switch;

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            // Create the main box to house all of it
            var menu_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            set_child (menu_box);

            // Audio input source selection box /////////////////////////////////////////////
            var audio_input_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

            var audio_input_label = new Gtk.Label (_("Sampler Source")) {
                halign = Gtk.Align.START,
                margin_start = 8
            };
            audio_input_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

            var audio_input_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                margin_top = 8,
                margin_bottom = 8,
                margin_start = 8,
                margin_end = 8,
                homogeneous = true
            };

            audio_input_buttons.add_css_class (Granite.STYLE_CLASS_LINKED);

            audio_input_mic = new Gtk.ToggleButton.with_label (_("Mic"));
            audio_input_buttons.append (audio_input_mic);
            audio_input_system = new Gtk.ToggleButton.with_label (_("System")) {
                group = audio_input_mic
            };
            audio_input_buttons.append (audio_input_system);
            audio_input_both = new Gtk.ToggleButton.with_label (_("Both")) {
                group = audio_input_mic
            };
            audio_input_buttons.append (audio_input_both);

            audio_input_box.append (audio_input_label);
            audio_input_box.append (audio_input_buttons);

            menu_box.append (audio_input_box);

            // Song note visualization channel selection ////////////////////////////////
            var song_note_channel_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

            var song_note_channel_label = new Gtk.Label (_("Visualize Song Layer")) {
                halign = Gtk.Align.START,
                margin_start = 8
            };
            song_note_channel_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

            song_channel_spin_button = new Gtk.SpinButton.with_range (0, 15, 1) {
                margin_top = 8,
                margin_bottom = 8,
                margin_start = 8,
                margin_end = 8,
                hexpand = true
            };

            song_note_channel_box.append (song_note_channel_label);
            song_note_channel_box.append (song_channel_spin_button);

            menu_box.append (song_note_channel_box);


            var header_separator_b = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_box.append (header_separator_b);

            // AutoFill Switch /////////////////////////////////////////////////////////
            auto_fill_item = new Granite.SwitchModelButton (_("Style Auto Fill-In")) {
                active = settings.autofill,
                tooltip_text = "Whether changing variation should automatically trigger a fill-in."
            };
            menu_box.append (auto_fill_item);
            auto_fill_item.get_style_context ().add_class ("h4");

            var header_separator_c = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_box.append (header_separator_c);

            // MIDI Input device selection /////////////////////////////////////////////
            device_input_item = new Granite.SwitchModelButton (_("Midi Input"));
            device_input_item.get_style_context ().add_class ("h4");

            revealer = new Gtk.Revealer ();
            revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN;

            var midi_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            device_list_box = new Gtk.ListBox () {
                activate_on_single_click = true,
                selection_mode = Gtk.SelectionMode.SINGLE
            };
            midi_box.append (device_list_box);
            midi_box.append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

            midi_split_switch = new Granite.SwitchModelButton (_("Split By Channel"));
            midi_split_switch.get_style_context ().add_class ("h4");

            //  midi_split_switch.active = Application.settings.get_boolean ("midi-split");

            midi_box.append (midi_split_switch);

            revealer.set_child (midi_box);

            menu_box.append (device_input_item);
            menu_box.append (revealer);
        }

        private void build_events () {
            song_channel_spin_button.value_changed.connect (() => {
                //  Core.SongPlayer.set_note_watch_channel ((int)(song_channel_spin_button.get_value ()));
            });

            auto_fill_item.notify["active"].connect (() => {
                settings.autofill = auto_fill_item.active;
                aw_core.style_engine_set_auto_fill (auto_fill_item.active);
            });

            // Show list of detected devices when the user enables MIDI Input
            device_input_item.notify["active"].connect (() => {
                revealer.reveal_child = device_input_item.active;
                if (device_input_item.active) {
                    var devices_found = aw_core.refresh_midi_devices ();
                    update_devices (devices_found);
                }
            });

            device_list_box.row_activated.connect ((row) => {
                DeviceItem device_item = row as DeviceItem;
                device_item.radio.active = !device_item.radio.active;

                if (device_item.radio.active) {
                    aw_core.connect_midi_device (device_item.device);
                } else {
                    aw_core.disconnect_midi_device (device_item.device);
                }
            });

            midi_split_switch.notify["active"].connect (() => {
                //  Application.settings.set_boolean ("midi-split", midi_split_switch.active);
            });
        }

        public void update_devices (Models.MIDIDevice[] devices) {
            debug ("Updating Device list");

            if (device_items != null && !device_items.is_empty ()) {
                foreach (var item in device_items) {
                    device_list_box.remove (item);
                }
            }

            device_items = new List<DeviceItem> ();

            for (int i = 0; i < devices.length; i++) {
                if (devices[i].input) {
                    var item = new DeviceItem (devices[i]);
                    device_list_box.insert (item, -1);
                    device_items.append (item);
                }
            }
        }
    }
}
