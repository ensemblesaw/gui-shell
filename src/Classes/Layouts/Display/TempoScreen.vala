namespace Ensembles.GtkShell.Layouts.Display {
    public class TempoScreen : Gtk.Grid {
        private Gtk.Label tempo_label;
        private Gtk.Button decrease_tempo_button;
        private Gtk.Button increase_tempo_button;
        private Gtk.Button close_button;
        private Gtk.Button tap_button;
        private Gtk.Button reset_button;

        public signal void close ();
        public signal void increase_tempo ();
        public signal void decrease_tempo ();
        public signal void reset ();

        private int width = 0;
        private bool update = true;

        construct {
            build_ui ();
            build_events ();
        }

        ~TempoScreen () {
            update = false;
        }

        private void build_ui () {
            width_request = 400;
            height_request = 200;
            margin_top = 64;
            can_target = false;
            valign = Gtk.Align.CENTER;
            hexpand = true;
            add_css_class ("tempo-screen");

            var upper_region = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8) {
                halign = Gtk.Align.CENTER,
                hexpand = true
            };
            attach (upper_region, 0, 0);

            decrease_tempo_button = new Gtk.Button.with_label ("−"); // UTF-8 subtract symbol
            decrease_tempo_button.add_css_class ("tempo-screen-text-button-big");
            upper_region.append (decrease_tempo_button);

            tempo_label = new Gtk.Label ("120") {
                width_request = 256
            };
            tempo_label.add_css_class ("tempo-label");
            upper_region.append (tempo_label);

            increase_tempo_button = new Gtk.Button.with_label ("+");
            increase_tempo_button.add_css_class ("tempo-screen-text-button-big");
            upper_region.append (increase_tempo_button);

            var bpm_label = new Gtk.Label ("BPM");
            bpm_label.add_css_class ("tempo-bpm-label");
            attach (bpm_label, 0, 1);

            var lower_region = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
                halign = Gtk.Align.CENTER,
                margin_top = 24
            };
            attach (lower_region, 0, 2);

            close_button = new Gtk.Button.from_icon_name ("window-close-symbolic");
            close_button.add_css_class ("outlined-button-alt");
            lower_region.append (close_button);

            tap_button = new Gtk.Button.with_label (_("Tap")) {
                width_request = 256
            };
            tap_button.add_css_class ("outlined-button-alt");
            lower_region.append (tap_button);

            reset_button = new Gtk.Button.from_icon_name ("edit-undo-symbolic");
            reset_button.add_css_class ("outlined-button-alt");
            lower_region.append (reset_button);
        }

        private void build_events () {
            add_tick_callback ((widget, frame_clock) => {
                if (width != get_width ()) {
                    width = get_width ();

                    margin_top = width / 20;
                }

                return update;
            });

            close_button.clicked.connect (() => {
                close ();
            });

            decrease_tempo_button.clicked.connect (() => {
                decrease_tempo ();
            });

            increase_tempo_button.clicked.connect (() => {
                increase_tempo ();
            });
        }

        public void pop_up () {
            add_css_class ("popup");
            can_target = true;
        }

        public void pop_down () {
            remove_css_class ("popup");
            can_target = false;
        }

        public void set_tempo (uint8 tempo) {
            tempo_label.set_text ("%u".printf (tempo));
        }
    }
}
