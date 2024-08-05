using Vinject;
using Ensembles.GtkShell;

namespace Ensembles.Services {
    extern static Injector di_container;

    public ServiceToken<string> st_app_id;
    public ServiceToken<string> st_version;
    public ServiceToken<string> st_display_ver;
    public ServiceToken<string> st_app_name;
    public ServiceToken<string> st_app_icon;

    public ServiceToken<Settings> st_settings;

    // UI tokens
    public ServiceToken<GtkShell.Shell> st_application;
    public ServiceToken<MainWindow> st_main_window;
    public ServiceToken<AppMenu> st_app_menu;
    public ServiceToken<ContextMenu> st_context_menu;
    public ServiceToken<UIMap> st_ui_map;

    // Layout tokensT
    public ServiceToken<Layouts.DesktopLayout> st_desktop_layout;
    public ServiceToken<Layouts.MobileLayout> st_mobile_layout;
    public ServiceToken<Layouts.KioskLayout> st_kiosk_layout;

    // Sub layouts
    public ServiceToken<Layouts.AssignablesBoard> st_assignables_board;
    public ServiceToken<Layouts.InfoDisplay> st_info_display;
    public ServiceToken<Layouts.SynthControlPanel> st_synth_control_panel;
    public ServiceToken<Layouts.VoiceNavPanel> st_voice_nav_panel;
    public ServiceToken<Layouts.MixerBoard> st_mixer_board;
    public ServiceToken<Layouts.SamplerPadsPanel> st_sampler_pads_panel;
    public ServiceToken<Layouts.StyleControlPanel> st_style_control_panel;
    public ServiceToken<Layouts.RegistryPanel> st_registry_panel;
    public ServiceToken<Layouts.KeyboardPanel> st_keyboard_panel;
    public ServiceToken<Layouts.JoyStick> st_joystick;
    public ServiceToken<Layouts.BeatVisualization> st_beat_visualization;

    public void configure_gtkshell_service (
        ShellBuilder.ShellBuilderCallback shell_builder_callback
    ) throws VinjectErrors {
        st_app_id = new ServiceToken<string> ();
        st_version = new ServiceToken<string> ();
        st_display_ver = new ServiceToken<string> ();
        st_app_name = new ServiceToken<string> ();
        st_app_icon = new ServiceToken<string> ();

        st_settings = new ServiceToken<Settings> ();

        st_application = new ServiceToken<GtkShell.Shell> ();
        st_main_window = new ServiceToken<MainWindow> ();
        st_app_menu = new ServiceToken<AppMenu> ();
        st_context_menu = new ServiceToken<ContextMenu> ();
        st_ui_map = new ServiceToken<UIMap> ();

        st_desktop_layout = new ServiceToken<Layouts.DesktopLayout> ();
        st_mobile_layout = new ServiceToken<Layouts.MobileLayout> ();
        st_kiosk_layout = new ServiceToken<Layouts.KioskLayout> ();

        st_assignables_board = new ServiceToken<Layouts.AssignablesBoard> ();
        st_info_display = new ServiceToken<Layouts.InfoDisplay> ();
        st_synth_control_panel = new ServiceToken<Layouts.SynthControlPanel> ();
        st_voice_nav_panel = new ServiceToken<Layouts.VoiceNavPanel> ();
        st_mixer_board = new ServiceToken<Layouts.MixerBoard> ();
        st_sampler_pads_panel = new ServiceToken<Layouts.SamplerPadsPanel> ();
        st_style_control_panel = new ServiceToken<Layouts.StyleControlPanel> ();
        st_registry_panel = new ServiceToken<Layouts.RegistryPanel> ();
        st_keyboard_panel = new ServiceToken<Layouts.KeyboardPanel> ();
        st_joystick = new ServiceToken<Layouts.JoyStick> ();
        st_beat_visualization = new ServiceToken<Layouts.BeatVisualization> ();

        var builder = new ShellBuilder ();
        shell_builder_callback (builder);

        di_container.register_constant (st_app_id, builder.app_id);
        di_container.register_constant (st_version, builder.version);
        di_container.register_constant (st_display_ver, builder.display_version);
        di_container.register_constant (st_app_name, builder.app_name);
        di_container.register_constant (st_app_icon, builder.icon_name);
        di_container.register_singleton<Ensembles.Settings, GLib.Settings> (
            st_settings, schema_id: st_app_id
        );
        di_container.register_singleton<GtkShell.Shell, Gtk.Application> (
            st_application,
            application_id: st_app_id,
            settings: st_settings
        );
        di_container.register_singleton<MainWindow, Gtk.ApplicationWindow> (
            st_main_window,
            application: st_application,
            aw_core: st_aw_core,
            settings: st_settings,
            title: st_app_name,
            icon_name: st_app_icon
        );
        di_container.register_singleton<UIMap, Object> (st_ui_map);
    }

    public string get_app_id () {
        try {
            return di_container.obtain (st_app_id);
        } catch (Vinject.VinjectErrors e) {
            Console.log ("FATAL: Dependency injection failed!", Console.LogLevel.ERROR);
        }

        return "";
    }
}
