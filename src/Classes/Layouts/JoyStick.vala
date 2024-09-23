/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class JoyStick : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Gtk.Button x_assign_button;
        private Gtk.Button y_assign_button;
        private Gtk.Box joystick_area;
        private Gtk.DrawingArea touch_feedback;
        private Gtk.Revealer main_revealer;



        private string x_label = "PITCH";
        private string y_label = "BRIGHTNESS";

        construct {
            build_ui ();
        }

        private void build_ui () {
            main_revealer = new Gtk.Revealer () {
                transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT,
                reveal_child = true
            };
            main_revealer.add_css_class ("joystick");
            attach (main_revealer, 0, 0);

            var main_grid = new Gtk.Grid () {
                margin_start = 4,
                margin_end = 4,
                margin_bottom = 4,
                margin_top = 4
            };
            main_revealer.set_child (main_grid);

            x_assign_button = new Gtk.Button.with_label (_("X Assign")) {
                vexpand = true
            };
            main_grid.attach (x_assign_button, 0, 0);

            y_assign_button = new Gtk.Button.with_label (_("Y Assign")) {
                vexpand = true
            };
            main_grid.attach (y_assign_button, 1, 0);

            joystick_area = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                height_request = 152,
                width_request = 152
            };
            main_grid.attach (joystick_area, 0, 1, 2);
            joystick_area.add_css_class ("joystick-touch-feedback");

            touch_feedback = new Gtk.DrawingArea () {
                vexpand = true,
                width_request = 152
            };
            joystick_area.append (touch_feedback);
            touch_feedback.set_draw_func (draw);
        }

        private void draw (Gtk.DrawingArea widget, Cairo.Context ctx, int width, int height) {
            ctx.set_line_width (1);
            ctx.set_source_rgb (0.2, 0.2, 0.2);
            ctx.move_to (width >> 1, 20);
            ctx.line_to (width >> 1, height - 20);
            ctx.move_to (20, height >> 1);
            ctx.line_to (width - 20, height >> 1);
            ctx.stroke ();

            Cairo.TextExtents x_extents;
            ctx.text_extents (x_label, out x_extents);

            ctx.set_source_rgb (0.5, 0.5, 0.5);
            ctx.move_to (12, (height >> 1) + (x_extents.width / 2.0));

            ctx.rotate (-Math.PI_2);
            ctx.show_text (x_label);
            ctx.rotate (Math.PI_2);

            Cairo.TextExtents y_extents;
            ctx.text_extents (y_label, out y_extents);

            ctx.set_source_rgb (0.5, 0.5, 0.5);
            ctx.move_to ((width >> 1) - (y_extents.width / 2.0), height - 6);


            ctx.show_text (y_label);
        }
    }
}
