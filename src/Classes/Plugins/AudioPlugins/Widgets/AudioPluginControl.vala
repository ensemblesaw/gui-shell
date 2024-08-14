/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.ArrangerWorkstation.Plugins.AudioPlugins;

namespace Ensembles.GtkShell.Plugins.AudioPlugins.Widgets {
    public class AudioPluginControl : Gtk.Box {
        private Gtk.IconSize widget_size;
        private float* variable;
        private unowned Port port;

        private Gtk.Label control_label;
        private Gtk.Label value_label;
        private Gtk.Label control_unit;

        public AudioPluginControl (Port port, Gtk.IconSize widget_size = Gtk.IconSize.NORMAL) {
            Object (
                margin_start: 26,
                margin_bottom: 8,
                margin_top: 8,
                margin_end: 26,
                hexpand: widget_size == Gtk.IconSize.NORMAL,
                halign: widget_size == Gtk.IconSize.NORMAL ? Gtk.Align.FILL : Gtk.Align.CENTER,
                orientation: Gtk.Orientation.VERTICAL
            );

            this.widget_size = widget_size;
            this.port = port;

            var lv2_control_port = port as Lv2.LV2ControlPort;

            if (lv2_control_port != null) {
                this.variable = &lv2_control_port.value;

                if (lv2_control_port.unit != "") {
                    control_unit = new Gtk.Label (lv2_control_port.unit);
                }
            }

            build_ui ();
        }

        private void build_ui () {
            add_css_class (Granite.STYLE_CLASS_CARD);

            control_label = new Gtk.Label (port.name) {
                margin_top = 12,
                margin_start = 16,
                margin_end = 16
            };
            control_label.add_css_class (Granite.STYLE_CLASS_H3_LABEL);

            if (widget_size == Gtk.IconSize.LARGE) {
                append (control_label);

                if (control_unit != null) {
                    append (control_unit);
                }

                var knob = new GtkShell.Widgets.Knob () {
                    width_request = 150,
                    height_request = 150,
                    margin_start = 16,
                    margin_end = 16,
                    margin_top = 12,
                    margin_bottom = 16,
                    draw_value = true
                };
                knob.add_css_class ("dark");

                append (knob);

                if (port is Lv2.LV2ControlPort) {
                    var lv2_control_port = (Lv2.LV2ControlPort) port;
                    knob.adjustment.lower = lv2_control_port.min_value;
                    knob.adjustment.upper = lv2_control_port.max_value;
                    knob.adjustment.step_increment = lv2_control_port.step;
                    knob.value = *variable;

                    if (lv2_control_port.stops.length > 0) {
                        for (uint8 k = 0; k < lv2_control_port.stops.length; k++) {
                            knob.add_mark (lv2_control_port.stops[k]);
                        }
                    }

                    knob.add_mark (lv2_control_port.min_value);
                    knob.add_mark (lv2_control_port.default_value);
                    knob.add_mark (lv2_control_port.max_value);
                }

                knob.value_changed.connect ((value) => {
                    *variable = (float) value;
                });
            } else {
                var label_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2) {
                    margin_end = 16
                };
                append (label_box);

                label_box.append (control_label);

                value_label = new Gtk.Label ("") {
                    hexpand = true,
                    valign = Gtk.Align.END,
                    halign = Gtk.Align.END
                };
                label_box.append (value_label);

                control_unit.valign = Gtk.Align.END;
                label_box.append (control_unit);

                var scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, null) {
                    margin_start = 16,
                    margin_end = 16,
                    margin_top = 8,
                    margin_bottom = 8
                };

                append (scale);

                if (port is Lv2.LV2ControlPort) {
                    var lv2_control_port = (Lv2.LV2ControlPort) port;

                    value_label.set_text (lv2_control_port.default_value.to_string ());

                    scale.adjustment.lower = lv2_control_port.min_value;
                    scale.adjustment.upper = lv2_control_port.max_value;
                    scale.adjustment.step_increment = lv2_control_port.step;
                    scale.adjustment.value = *variable;

                    if (lv2_control_port.stops.length > 0) {
                        for (uint8 k = 0; k < lv2_control_port.stops.length; k++) {
                            scale.add_mark (
                                lv2_control_port.stops[k], Gtk.PositionType.RIGHT,
                                null
                            );
                        }
                    }

                    scale.add_mark (
                        lv2_control_port.min_value, Gtk.PositionType.RIGHT,
                        null
                    );
                    scale.add_mark (
                        lv2_control_port.default_value,
                        Gtk.PositionType.RIGHT,
                        null
                    );
                    scale.add_mark (
                        lv2_control_port.max_value,
                        Gtk.PositionType.RIGHT,
                        null
                    );
                }

                scale.value_changed.connect ((range) => {
                    *variable = (float) range.get_value ();
                    value_label.set_text ((*variable).to_string ());
                });
            }
        }
    }
}
