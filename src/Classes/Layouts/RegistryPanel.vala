/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class RegistryPanel : Gtk.Box, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }
        public unowned UIMap ui_map { private get; construct; }

        private Gtk.SpinButton bank_select;
        private Widgets.MIDIControllableButton registry_0_button;
        private Widgets.MIDIControllableButton registry_1_button;
        private Widgets.MIDIControllableButton registry_2_button;
        private Widgets.MIDIControllableButton registry_3_button;
        private Widgets.MIDIControllableButton registry_4_button;
        private Widgets.MIDIControllableButton registry_5_button;
        private Widgets.MIDIControllableButton registry_6_button;
        private Widgets.MIDIControllableButton registry_7_button;
        private Widgets.MIDIControllableButton registry_8_button;
        private Widgets.MIDIControllableButton registry_9_button;
        private Gtk.Button memorize_button;

        // URIS
        public const string UI_URI_BANK_UP = "gtk.registry.bank_up";
        public const string UI_URI_BANK_DOWN = "gtk.registry.bank_down";
        public const string UI_URI_SLOT_0 = "gtk.registry.slot_0";
        public const string UI_URI_SLOT_1 = "gtk.registry.slot_1";
        public const string UI_URI_SLOT_2 = "gtk.registry.slot_2";
        public const string UI_URI_SLOT_3 = "gtk.registry.slot_3";
        public const string UI_URI_SLOT_4 = "gtk.registry.slot_4";
        public const string UI_URI_SLOT_5 = "gtk.registry.slot_5";
        public const string UI_URI_SLOT_6 = "gtk.registry.slot_6";
        public const string UI_URI_SLOT_7 = "gtk.registry.slot_7";
        public const string UI_URI_SLOT_8 = "gtk.registry.slot_8";
        public const string UI_URI_SLOT_9 = "gtk.registry.slot_9";

        construct {
            build_ui ();
        }

        private void build_ui () {
            orientation = Gtk.Orientation.HORIZONTAL;
            spacing = 4;
            hexpand = true;
            add_css_class ("panel");

            var bank_select_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            bank_select = new Gtk.SpinButton.with_range (1, 16, 1) {
                height_request = 28,
                digits = 0
            };
            bank_select_box.append (bank_select);
            bank_select_box.append (new Gtk.Label (_("BANK")) { opacity = 0.5 } );
            append (bank_select_box);

            var registry_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (registry_box);
            var registry_btn_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                homogeneous = true
            };
            registry_btn_box.add_css_class (Granite.STYLE_CLASS_LINKED);
            registry_box.append (registry_btn_box);

            registry_0_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_0, "0") {
                height_request = 28
            };
            registry_btn_box.append (registry_0_button);

            registry_1_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_1, "1");
            registry_btn_box.append (registry_1_button);

            registry_2_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_2, "2");
            registry_btn_box.append (registry_2_button);

            registry_3_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_3, "3");
            registry_btn_box.append (registry_3_button);

            registry_4_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_4, "4");
            registry_btn_box.append (registry_4_button);

            registry_5_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_5, "5");
            registry_btn_box.append (registry_5_button);

            registry_6_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_6, "6");
            registry_btn_box.append (registry_6_button);

            registry_7_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_7, "7");
            registry_btn_box.append (registry_7_button);

            registry_8_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_8, "8");
            registry_btn_box.append (registry_8_button);

            registry_9_button = new Widgets.MIDIControllableButton.with_label (UI_URI_SLOT_9, "9");
            registry_btn_box.append (registry_9_button);

            registry_box.append (new Gtk.Label (_("REGISTRY MEMORY")) { opacity = 0.5 } );

            var memorize_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (memorize_box);
            memorize_button = new Gtk.Button.from_icon_name ("go-down-symbolic") {
                height_request = 28
            };
            memorize_button.remove_css_class ("image-button");
            memorize_box.append (memorize_button);
            memorize_box.append (new Gtk.Label (_("MEMORIZE")) { opacity = 0.5 } );
        }
    }
}
