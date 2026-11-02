{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # A keybinds table replaces Umbriel's built-ins. Start with the complete
  # example from the pinned compositor, including its Noctalia window rules.
  defaults = builtins.fromTOML (builtins.readFile "${inputs.umbriel}/examples/config.toml");
  noctalia = lib.getExe config.programs.noctalia.package;
in
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.umbriel.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    # Umbriel starts the shell only for its own session, leaving Plasma usable.
    systemd.enable = false;
    settings = {
      shell = {
        font_family = "Noto Sans";
        polkit_agent = true;
        launch_apps_as_systemd_services = true;
      };
      theme.templates.builtin_ids = [ "umbriel" ];
    };
  };

  programs.umbriel = {
    enable = true;
    settings = lib.recursiveUpdate defaults {
      general.autostart = [ noctalia ];
      include.optional.files = [ "${config.xdg.configHome}/umbriel/noctalia.toml" ];
      layout = {
        mode = "scrolling";
        gap = 5;
      };
      input = {
        keyboard = {
          options = "ctrl:hyper_capscontrol";
          repeat_delay = 250;
          repeat_rate = 100;
        };
        touchpad = {
          tap = true;
          natural_scroll = true;
          accel_profile = "flat";
          sensitivity = 0.5;
        };
      };
      keybinds = {
        "Mod+Return" = {
          action = "spawn ${lib.getExe pkgs.kitty}";
          repeat = false;
        };
        "Mod+S" = "spawn emacsclient -c -a emacs";
        "Mod+Ctrl+L" = "spawn ${noctalia} msg session lock";
        "Mod+Ctrl+S" = "spawn ${noctalia} msg panel-toggle control-center";
        "Mod+Shift+Comma" = "spawn ${noctalia} msg settings-toggle";
        "Alt+Tab" = "spawn ${noctalia} msg window-switcher hold";
        "Alt+Shift+Tab" = "spawn ${noctalia} msg window-switcher hold reverse";
        "Print" = "spawn ${noctalia} msg screenshot-region";
      };
    };
  };
}
