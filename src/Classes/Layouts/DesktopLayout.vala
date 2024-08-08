/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class DesktopLayout : Gtk.Grid, ControlSurface {
        public bool active { get; set; }

        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        public unowned AssignablesBoard assignables_board { private get; construct; }
        public unowned InfoDisplay info_display { private get; construct; }
        public unowned SynthControlPanel synth_control_panel { private get; construct; }
        public unowned VoiceNavPanel voice_nav_panel { private get; construct; }
        public unowned MixerBoard mixer_board { private get; construct; }
        public unowned SamplerPadsPanel sampler_pads_panel { private get; construct; }
        public unowned StyleControlPanel style_control_panel { private get; construct; }
        public unowned RegistryPanel registry_panel { private get; construct; }
        public unowned KeyboardPanel keyboard { private get; construct; }
        public unowned JoyStick joystick { private get; construct; }
        public Gtk.Button start_button;

        private Gtk.CenterBox center_box;
        private Gtk.Box collapsed_box;
        private Gtk.Box center_col_container;
        private Gtk.Revealer left_collapser;
        private Gtk.Revealer right_collapser;
        private Gtk.Button left_reveal_button;
        private Gtk.Button right_reveal_button;
        private Gtk.Box left_column;
        private Gtk.Box center_column;
        private Gtk.Box right_column;
        private Gtk.Grid bottom_row;
        private Gtk.CenterBox bottom_row_box;
        private Gtk.Revealer bottom_row_revealer;

        private int width;
        private int height;
        private bool update = true;
        private bool collapsed_view = true;

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            width_request = 800;
            height_request = 676;
            hexpand = true;
            vexpand = true;

            center_box = new Gtk.CenterBox () {
                hexpand = true,
                vexpand = true
            };
            attach (center_box, 0, 0);

            left_column = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                vexpand = true
            };
            center_box.set_start_widget (left_column);

            center_column = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                vexpand = true,
                hexpand = true
            };
            center_box.set_center_widget (center_column);

            right_column = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                vexpand = true
            };
            center_box.set_end_widget (right_column);

            collapsed_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                visible = false
            };
            attach (collapsed_box, 0, 1);

            left_reveal_button = new Gtk.Button.from_icon_name ("view-more-symbolic") {
                hexpand = true
            };
            collapsed_box.append (left_reveal_button);

            left_collapser = new Gtk.Revealer () {
                transition_type = Gtk.RevealerTransitionType.SLIDE_LEFT,
                reveal_child = false,
                hexpand = false
            };
            collapsed_box.append (left_collapser);

            center_col_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            collapsed_box.append (center_col_container);

            right_collapser = new Gtk.Revealer () {
                transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT,
                reveal_child = true,
                hexpand = false
            };
            collapsed_box.append (right_collapser);

            right_reveal_button = new Gtk.Button.from_icon_name ("view-more-symbolic") {
                visible = false,
                hexpand = true
            };
            collapsed_box.append (right_reveal_button);

            bottom_row_revealer = new Gtk.Revealer () {
                reveal_child = true,
                hexpand = true
            };
            attach (bottom_row_revealer, 0, 2);

            bottom_row = new Gtk.Grid () {
                hexpand = true
            };
            bottom_row_revealer.set_child (bottom_row);

            bottom_row_box = new Gtk.CenterBox ();
            bottom_row.attach (bottom_row_box, 0, 0, 2);

            var start_button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            start_button_box.add_css_class ("panel");
            bottom_row_box.set_center_widget (start_button_box);

            start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic") {
                width_request = 64,
                height_request = 32
            };
            start_button.add_css_class (Granite.STYLE_CLASS_DESTRUCTIVE_ACTION);
            start_button.remove_css_class ("image-button");
            start_button.clicked.connect (() => {
                aw_core.style_engine_toggle_playback ();
            });

            start_button_box.append (start_button);
            start_button_box.append (new Gtk.Label (_("START/STOP")) { opacity = 0.5 });
        }

        public void reparent () {
            if (!active) {
                print ("Desktop\n");
                active = true;
                assignables_board.unparent ();
                info_display.unparent ();
                synth_control_panel.unparent ();
                voice_nav_panel.unparent ();
                mixer_board.unparent ();
                sampler_pads_panel.unparent ();
                style_control_panel.unparent ();
                registry_panel.unparent ();
                keyboard.unparent ();
                joystick.unparent ();

                left_column.append (assignables_board);
                left_column.append (voice_nav_panel);

                center_column.append (info_display);
                info_display.fill_screen = false;
                center_column.append (mixer_board);

                right_column.append (synth_control_panel);
                right_column.append (sampler_pads_panel);

                bottom_row_box.set_start_widget (style_control_panel);
                bottom_row_box.set_end_widget (registry_panel);
                bottom_row.attach (joystick, 0, 1);
                bottom_row.attach (keyboard, 1, 1);

            }
        }

        private void build_events () {
            add_tick_callback (() => {
                if (width != get_width () || height != get_height ()) {
                    width = get_width ();
                    height = get_height ();

                    if (width > 1278) {
                        if (collapsed_view) {
                            collapsed_view = false;
                            collapsed_box.visible = false;
                            left_column.unparent ();
                            center_column.unparent ();
                            right_column.unparent ();
                            center_box.set_start_widget (left_column);
                            center_box.set_center_widget (center_column);
                            center_box.set_end_widget (right_column);
                            center_box.visible = true;
                        }
                    } else {
                        if (!collapsed_view) {
                            collapsed_view = true;
                            center_box.visible = false;
                            left_column.unparent ();
                            center_column.unparent ();
                            right_column.unparent ();
                            left_collapser.set_child (left_column);
                            center_col_container.append (center_column);
                            right_collapser.set_child  (right_column);
                            collapsed_box.visible = true;
                        }
                    }
                }

                return update;
            });

            left_reveal_button.clicked.connect (() => {
                right_reveal_button.visible = true;
                left_reveal_button.visible = false;

                right_collapser.reveal_child = false;
                left_collapser.reveal_child = true;
            });

            right_reveal_button.clicked.connect (() => {
                left_reveal_button.visible = true;
                right_reveal_button.visible = false;

                left_collapser.reveal_child = false;
                right_collapser.reveal_child = true;
            });
        }
    }
}
