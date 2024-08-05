using Ensembles.Services;

namespace Ensembles.GtkShell {
    public class Shell : Gtk.Application {
        // Command Line Parameters
        private string[]? cl_arg_file = null;
        private bool cl_raw_midi_input = false;
        private bool cl_kiosk_mode = false;
        private bool cl_verbose = false;

        construct {
            flags |= ApplicationFlags.HANDLES_OPEN |
            ApplicationFlags.HANDLES_COMMAND_LINE;
        }

        protected override void activate () {
            try {
                var resource_path = Constants.RESOURCE_PATH + "/gresource.gresource";
                resources_register (Resource.load (resource_path));
                Theme.init_theme ();

                Console.log ("Initializing Main Window");
                di_container.obtain (st_main_window).build ();
                di_container.obtain (st_main_window).show_ui ();

                Console.log (
                    "GUI Initialization Complete!",
                    Console.LogLevel.SUCCESS
                );

                di_container.obtain (st_aw_core).load_data_async.begin ();

                var _settings = di_container.obtain (st_settings);
                var _version = di_container.obtain (st_version);

                if (_settings.version != _version) {
                    _settings.version = _version;

                    // Show welcome screen
                }
            } catch (Error e) {
                error (e.message);
            }
        }

        protected override int command_line (ApplicationCommandLine cmd) {
            string[] args_cmd = cmd.get_arguments ();
            unowned string[] args = args_cmd;

            GLib.OptionEntry [] options = new OptionEntry [5];
            options [0] = { "", 0, 0, OptionArg.STRING_ARRAY, ref cl_arg_file, null, "URI" };
            options [1] = { "raw", 0, 0, OptionArg.NONE, ref cl_raw_midi_input, _("Enable Raw MIDI Input"), null };
            options [2] = { "kiosk", 0, 0, OptionArg.NONE, ref cl_kiosk_mode, _("Only show the info display"), null };
            options [3] = { "verbose", 0, 0, OptionArg.NONE, ref cl_verbose,
                _("Print debug messages to terminal"), null };
            options [4] = { null };

            var opt_context = new OptionContext ("actions");
            opt_context.add_main_entries (options, null);
            try {
                opt_context.parse (ref args);
            } catch (Error err) {
                warning (err.message);
                return -1;
            }

            Console.verbose = cl_verbose;

            if (cl_raw_midi_input) {
                Console.log ("Raw MIDI Input Enabled! You can now enable midi input and connect your DAW\n");
            }

            if (cl_kiosk_mode) {
                Console.log ("Starting Ensembles in Kiosk Mode\n");
            }

            if (cl_arg_file != null && cl_arg_file[0] != null) {
                if (GLib.FileUtils.test (cl_arg_file[0], GLib.FileTest.EXISTS) &&
                    cl_arg_file[0].down ().has_suffix (".mid")) {
                    File file = File.new_for_path (cl_arg_file[0]);
                    open ({ file }, "");
                    return 0;
                }
            }

            activate ();
            return 0;
        }
    }
}
