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
        private Widgets.StyledButton registry_0_button;
        private Widgets.StyledButton registry_1_button;
        private Widgets.StyledButton registry_2_button;
        private Widgets.StyledButton registry_3_button;
        private Widgets.StyledButton registry_4_button;
        private Widgets.StyledButton registry_5_button;
        private Widgets.StyledButton registry_6_button;
        private Widgets.StyledButton registry_7_button;
        private Widgets.StyledButton registry_8_button;
        private Widgets.StyledButton registry_9_button;
        private Gtk.Button memorize_button;

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
                height_request = 32,
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

            registry_0_button = new Widgets.StyledButton.with_label ("registry-0", "0") {
                height_request = 32
            };
            registry_btn_box.append (registry_0_button);

            registry_1_button = new Widgets.StyledButton.with_label ("registry-1", "1");
            registry_btn_box.append (registry_1_button);

            registry_2_button = new Widgets.StyledButton.with_label ("registry-2", "2");
            registry_btn_box.append (registry_2_button);

            registry_3_button = new Widgets.StyledButton.with_label ("registry-3", "3");
            registry_btn_box.append (registry_3_button);

            registry_4_button = new Widgets.StyledButton.with_label ("registry-4", "4");
            registry_btn_box.append (registry_4_button);

            registry_5_button = new Widgets.StyledButton.with_label ("registry-5", "5");
            registry_btn_box.append (registry_5_button);

            registry_6_button = new Widgets.StyledButton.with_label ("registry-6", "6");
            registry_btn_box.append (registry_6_button);

            registry_7_button = new Widgets.StyledButton.with_label ("registry-7", "7");
            registry_btn_box.append (registry_7_button);

            registry_8_button = new Widgets.StyledButton.with_label ("registry-8", "8");
            registry_btn_box.append (registry_8_button);

            registry_9_button = new Widgets.StyledButton.with_label ("registry-9", "9");
            registry_btn_box.append (registry_9_button);

            registry_box.append (new Gtk.Label (_("REGISTRY MEMORY")) { opacity = 0.5 } );

            var memorize_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (memorize_box);
            memorize_button = new Gtk.Button.from_icon_name ("go-down-symbolic") {
                height_request = 32
            };
            memorize_button.remove_css_class ("image-button");
            memorize_box.append (memorize_button);
            memorize_box.append (new Gtk.Label (_("MEMORIZE")) { opacity = 0.5 } );
        }
    }
}
