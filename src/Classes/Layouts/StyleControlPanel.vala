/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.Models;

namespace Ensembles.GtkShell.Layouts {
    public class StyleControlPanel : Gtk.Box, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }
        public unowned UIMap ui_map { private get; construct; }

        private Widgets.MIDIControllableButton intro_1_button;
        private Widgets.MIDIControllableButton intro_2_button;
        private Widgets.MIDIControllableButton intro_3_button;
        private Widgets.MIDIControllableButton break_button;
        private Widgets.MIDIControllableButton variation_a_button;
        private Widgets.MIDIControllableButton variation_b_button;
        private Widgets.MIDIControllableButton variation_c_button;
        private Widgets.MIDIControllableButton variation_d_button;
        private Widgets.MIDIControllableButton ending_1_button;
        private Widgets.MIDIControllableButton ending_2_button;
        private Widgets.MIDIControllableButton ending_3_button;
        private Widgets.MIDIControllableButton sync_start_button;

        private StylePartType current_part = StylePartType.VARIATION_A;
        private StylePartType next_part = StylePartType.VARIATION_A;

        public signal void context_menu (MIDIControllable midi_controllable_widget);

        // URIS
        public const string UI_URI_INTRO1 = "gtk.stylecpl.int1";
        public const string UI_URI_INTRO2 = "gtk.stylecpl.int2";
        public const string UI_URI_INTRO3 = "gtk.stylecpl.int3";
        public const string UI_URI_VARIATION_A = "gtk.stylecpl.var_a";
        public const string UI_URI_VARIATION_B = "gtk.stylecpl.var_b";
        public const string UI_URI_VARIATION_C = "gtk.stylecpl.var_c";
        public const string UI_URI_VARIATION_D = "gtk.stylecpl.var_d";
        public const string UI_URI_ENDING1 = "gtk.stylecpl.end1";
        public const string UI_URI_ENDING2 = "gtk.stylecpl.end2";
        public const string UI_URI_ENDING3 = "gtk.stylecpl.end3";
        public const string UI_URI_BREAK = "gtk.stylecpl.brk";
        public const string UI_URI_SYNC = "gtk.stylecpl.sync";

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            orientation = Gtk.Orientation.HORIZONTAL;
            spacing = 4;
            hexpand = true;
            add_css_class ("panel");

            var intro_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (intro_box);

            var intro_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                homogeneous = true
            };
            intro_button_box.add_css_class (Granite.STYLE_CLASS_LINKED);
            intro_box.append (intro_button_box);
            intro_box.append (new Gtk.Label (_("INTRO")) { opacity = 0.5 } );

            var variation_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (variation_box);

            var variation_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                homogeneous = true
            };
            variation_button_box.add_css_class (Granite.STYLE_CLASS_LINKED);
            variation_box.append (variation_button_box);
            variation_box.append (new Gtk.Label (_("VARIATION/FILL-IN")) { opacity = 0.5 } );

            var break_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (break_box);

            break_button = new Widgets.MIDIControllableButton.from_icon_name (UI_URI_BREAK, "style-break-symbolic") {
                tooltip_text = "Break",
                has_tooltip = true,
                hexpand = true,
                height_request = 32
            };
            break_button.remove_css_class ("image-button");
            break_box.append (break_button);
            break_box.append (new Gtk.Label (_("BREAK")) { opacity = 0.5 } );

            var ending_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (ending_box);

            var ending_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                homogeneous = true
            };
            ending_button_box.add_css_class (Granite.STYLE_CLASS_LINKED);
            ending_box.append (ending_button_box);
            ending_box.append (new Gtk.Label (_("ENDING")) { opacity = 0.5 } );

            intro_1_button = new Widgets.MIDIControllableButton.with_label (UI_URI_INTRO1, _("1")) {
                height_request = 32
            };
            intro_button_box.append (intro_1_button);
            intro_2_button = new Widgets.MIDIControllableButton.with_label (UI_URI_INTRO2,_("2")) {
                height_request = 32
            };
            intro_button_box.append (intro_2_button);
            intro_3_button = new Widgets.MIDIControllableButton.with_label (UI_URI_INTRO3,_("3")) {
                height_request = 32
            };
            intro_button_box.append (intro_3_button);

            variation_a_button = new Widgets.MIDIControllableButton.with_label (UI_URI_VARIATION_A,_("A")) {
                height_request = 32
            };
            variation_button_box.append (variation_a_button);
            variation_b_button = new Widgets.MIDIControllableButton.with_label (UI_URI_VARIATION_B,_("B")) {
                height_request = 32
            };
            variation_button_box.append (variation_b_button);
            variation_c_button = new Widgets.MIDIControllableButton.with_label (UI_URI_VARIATION_C,_("C")) {
                height_request = 32
            };
            variation_button_box.append (variation_c_button);
            variation_d_button = new Widgets.MIDIControllableButton.with_label (UI_URI_VARIATION_D,_("D")) {
                height_request = 32
            };
            variation_button_box.append (variation_d_button);

            ending_1_button = new Widgets.MIDIControllableButton.with_label (UI_URI_ENDING1,_("1")) {
                height_request = 32
            };
            ending_button_box.append (ending_1_button);
            ending_2_button = new Widgets.MIDIControllableButton.with_label (UI_URI_ENDING2,_("2")) {
                height_request = 32
            };
            ending_button_box.append (ending_2_button);
            ending_3_button = new Widgets.MIDIControllableButton.with_label (UI_URI_ENDING3,_("3")) {
                height_request = 32
            };
            ending_button_box.append (ending_3_button);

            var sync_start_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (sync_start_box);
            sync_start_button = new Widgets.MIDIControllableButton.from_icon_name (UI_URI_SYNC, "style-sync-start-symbolic") {
                tooltip_text = "Sync Start / Stop",
                has_tooltip = true,
                hexpand = true,
                height_request = 32
            };
            sync_start_button.remove_css_class ("image-button");
            sync_start_box.append (sync_start_button);
            sync_start_box.append (new Gtk.Label (_("SYNC")) { opacity = 0.5 } );

            highlight_part ();
        }

        private void build_events () {
            intro_1_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.INTRO_1);
            });

            intro_1_button.menu_activated.connect (() => {
                context_menu (intro_1_button);
            });

            intro_2_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.INTRO_2);
            });

            intro_2_button.menu_activated.connect (() => {
                context_menu (intro_2_button);
            });

            intro_3_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.INTRO_3);
            });

            intro_3_button.menu_activated.connect (() => {
                context_menu (intro_3_button);
            });

            variation_a_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.VARIATION_A);
            });

            variation_a_button.menu_activated.connect (() => {
                context_menu (variation_a_button);
            });

            variation_b_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.VARIATION_B);
            });

            variation_b_button.menu_activated.connect (() => {
                context_menu (variation_b_button);
            });

            variation_c_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.VARIATION_C);
            });

            variation_c_button.menu_activated.connect (() => {
                context_menu (variation_a_button);
            });

            variation_d_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.VARIATION_D);
            });

            variation_d_button.menu_activated.connect (() => {
                context_menu (variation_d_button);
            });

            ending_1_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.ENDING_1);
            });

            ending_1_button.menu_activated.connect (() => {
                context_menu (ending_1_button);
            });

            ending_2_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.ENDING_2);
            });

            ending_2_button.menu_activated.connect (() => {
                context_menu (ending_2_button);
            });

            ending_3_button.clicked.connect (() => {
                aw_core.style_engine_queue_part (StylePartType.ENDING_3);
            });

            ending_3_button.menu_activated.connect (() => {
                context_menu (ending_3_button);
            });

            aw_core.on_current_part_change.connect ((part) => {
                current_part = part;
                highlight_part ();
            });

            aw_core.on_next_part_change.connect ((part) => {
                next_part = part;
                highlight_part ();
            });

            sync_start_button.clicked.connect (() => {
                aw_core.style_engine_sync ();
            });

            aw_core.on_sync_change.connect ((active) => {
                if (active) {
                    sync_start_button.add_css_class ("pulse");
                } else {
                    sync_start_button.remove_css_class ("pulse");
                }
            });

            sync_start_button.menu_activated.connect (() => {
                context_menu (sync_start_button);
            });

            break_button.clicked.connect (() => {
                aw_core.style_engine_break ();
            });

            break_button.menu_activated.connect (() => {
                context_menu (break_button);
            });

            aw_core.on_break_change.connect ((active) => {
                if (active) {
                    break_button.add_css_class ("pulse");
                } else {
                    break_button.remove_css_class ("pulse");
                }
            });

            aw_core.midi_device_on_ui_control.connect ((route) => {
                switch (ui_map.unmap_uri (route)) {
                    case UI_URI_INTRO1:
                        aw_core.style_engine_queue_part (StylePartType.INTRO_1);
                        break;
                    case UI_URI_INTRO2:
                        aw_core.style_engine_queue_part (StylePartType.INTRO_2);
                        break;
                    case UI_URI_INTRO3:
                        aw_core.style_engine_queue_part (StylePartType.INTRO_3);
                        break;
                    case UI_URI_VARIATION_A:
                        aw_core.style_engine_queue_part (StylePartType.VARIATION_A);
                        break;
                    case UI_URI_VARIATION_B:
                        aw_core.style_engine_queue_part (StylePartType.VARIATION_B);
                        break;
                    case UI_URI_VARIATION_C:
                        aw_core.style_engine_queue_part (StylePartType.VARIATION_C);
                        break;
                    case UI_URI_VARIATION_D:
                        aw_core.style_engine_queue_part (StylePartType.VARIATION_D);
                        break;
                    case UI_URI_BREAK:
                        aw_core.style_engine_break ();
                        break;
                    case UI_URI_ENDING1:
                        aw_core.style_engine_queue_part (StylePartType.ENDING_1);
                        break;
                    case UI_URI_ENDING2:
                        aw_core.style_engine_queue_part (StylePartType.ENDING_2);
                        break;
                    case UI_URI_ENDING3:
                        aw_core.style_engine_queue_part (StylePartType.ENDING_3);
                        break;
                    case UI_URI_SYNC:
                        aw_core.style_engine_sync ();
                        break;
                }
            });
        }

        private void highlight_part () {
            Idle.add (() => {
                switch (current_part) {
                    case StylePartType.INTRO_1:
                    intro_1_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.INTRO_2:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.INTRO_3:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.ENDING_1:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.ENDING_2:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.ENDING_3:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.VARIATION_A:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.VARIATION_B:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.VARIATION_C:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.VARIATION_D:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.FILL_A:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.add_css_class ("pulse-fill");
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.FILL_B:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.add_css_class ("pulse-fill");
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.FILL_C:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.add_css_class ("pulse-fill");
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.remove_css_class ("pulse-fill");
                    break;
                    case StylePartType.FILL_D:
                    intro_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    intro_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_1_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_2_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    ending_3_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_a_button.remove_css_class ("pulse-fill");
                    variation_b_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_b_button.remove_css_class ("pulse-fill");
                    variation_c_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_c_button.remove_css_class ("pulse-fill");
                    variation_d_button.remove_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                    variation_d_button.add_css_class ("pulse-fill");
                    break;
                    default:
                    break;
                }

                if (current_part != next_part) {
                    switch (next_part) {
                        case StylePartType.INTRO_1:
                        intro_1_button.add_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.INTRO_2:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.add_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.INTRO_3:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.add_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.ENDING_1:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.add_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.ENDING_2:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.add_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.ENDING_3:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.add_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.VARIATION_A:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.add_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.VARIATION_B:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.add_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.VARIATION_C:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.add_css_class ("pulse");
                        variation_d_button.remove_css_class ("pulse");
                        break;
                        case StylePartType.VARIATION_D:
                        intro_1_button.remove_css_class ("pulse");
                        intro_2_button.remove_css_class ("pulse");
                        intro_3_button.remove_css_class ("pulse");
                        ending_1_button.remove_css_class ("pulse");
                        ending_2_button.remove_css_class ("pulse");
                        ending_3_button.remove_css_class ("pulse");
                        variation_a_button.remove_css_class ("pulse");
                        variation_b_button.remove_css_class ("pulse");
                        variation_c_button.remove_css_class ("pulse");
                        variation_d_button.add_css_class ("pulse");
                        break;
                        default:
                        break;
                    }
                } else {
                    intro_1_button.remove_css_class ("pulse");
                    intro_2_button.remove_css_class ("pulse");
                    intro_3_button.remove_css_class ("pulse");
                    ending_1_button.remove_css_class ("pulse");
                    ending_2_button.remove_css_class ("pulse");
                    ending_3_button.remove_css_class ("pulse");
                    variation_a_button.remove_css_class ("pulse");
                    variation_b_button.remove_css_class ("pulse");
                    variation_c_button.remove_css_class ("pulse");
                    variation_d_button.remove_css_class ("pulse");
                }

                return false;
            });
        }
    }
}
