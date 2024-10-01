# Set constants
conf_data = configuration_data ()
conf_data = configuration_data ()
conf_data.set_quoted('RESOURCEPATH', join_paths (get_option ('prefix'), get_option ('datadir'), meson.project_name(), 'resources'))

config_vala = configure_file (
    input: 'Config.vala.in',
    output: 'Config.vala',
    configuration: conf_data
)

classes = files (
    # Shell
    'Classes/Shell.vala',
    'Classes/ShellBuilder.vala',
    'Classes/Services.vala',
    'Classes/Settings.vala',
    'Classes/Theme.vala',
    'Classes/UIMap.vala',

    'Classes/MainWindow.vala',

    'Classes/Layouts/AppMenu.vala',
    'Classes/Layouts/DesktopLayout.vala',
    'Classes/Layouts/MobileLayout.vala',
    'Classes/Layouts/KioskLayout.vala',
    'Classes/Layouts/InfoDisplay.vala',
    'Classes/Layouts/KeyboardPanel.vala',
    'Classes/Layouts/BeatVisualization.vala',
    'Classes/Layouts/MixerBoard.vala',
    'Classes/Layouts/AssignablesBoard.vala',
    'Classes/Layouts/RegistryPanel.vala',
    'Classes/Layouts/SamplerPadsPanel.vala',
    'Classes/Layouts/StyleControlPanel.vala',
    'Classes/Layouts/SynthControlPanel.vala',
    'Classes/Layouts/VoiceNavPanel.vala',
    'Classes/Layouts/PluginView.vala',
    'Classes/Layouts/JoyStick.vala',

    'Classes/Layouts/Display/DisplayWindow.vala',
    'Classes/Layouts/Display/HomeScreen.vala',
    'Classes/Layouts/Display/StyleScreen.vala',
    'Classes/Layouts/Display/VoiceScreen.vala',
    'Classes/Layouts/Display/DSPScreen.vala',
    'Classes/Layouts/Display/AudioPluginPicker.vala',
    'Classes/Layouts/Display/PluginScreen.vala',
    'Classes/Layouts/Display/ModulatorScreen.vala',
    'Classes/Layouts/Display/TempoScreen.vala',

    'Classes/Widgets/DeviceItem.vala',
    'Classes/Widgets/Knob.vala',
    'Classes/Widgets/MasterKnob.vala',
    'Classes/Widgets/Key.vala',
    'Classes/Widgets/Octave.vala',
    'Classes/Widgets/Keyboard.vala',
    'Classes/Widgets/Drumkit.vala',
    'Classes/Widgets/ContextMenu.vala',
    'Classes/Widgets/MIDIControllableButton.vala',
    'Classes/Widgets/MIDIControllableSpinButton.vala',
    'Classes/Widgets/ToggleButton.vala',
    'Classes/Widgets/ScrollDial.vala',

    'Classes/Widgets/Display/WheelScrollableWidget.vala',
    'Classes/Widgets/Display/VoiceMenuItem.vala',
    'Classes/Widgets/Display/StyleMenuItem.vala',
    'Classes/Widgets/Display/DSPMenuItem.vala',
    'Classes/Widgets/Display/DSPInstanceMenuItem.vala',
    'Classes/Widgets/Display/EqualizerBar.vala',
    'Classes/Widgets/Display/GraphicalModulator.vala',
    'Classes/Widgets/Display/ModulatorScale.vala',

    'Classes/Plugins/AudioPlugins/Widgets/AudioPluginControl.vala',

    'Classes/Utils/AccentColors.vala',
    'Classes/Utils/DisplayTheme.vala',

    'Classes/Dialogs/PowerDialog.vala',
    'Classes/Dialogs/MIDIAssignDialog.vala'
)

interfaces = files (
    'Interfaces/ControlSurface.vala',
    'Interfaces/ContextMenuTrigger.vala',
    'Interfaces/MIDIControllable.vala'
)

sources = [interfaces, classes]
