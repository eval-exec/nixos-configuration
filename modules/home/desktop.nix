{ config, pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    configPackages = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = "~/Music";
      extraConfig = ''
        auto_update "yes"
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
    sxhkd = {
      enable = true;
      extraConfig = "";
      keybindings = {
        "super + f" = "${config.home.homeDirectory}/Scripts/apps/terminal.sh";
        "super + s" = "${config.home.homeDirectory}/Scripts/apps/emacs.sh";
      };
    };
  };

  xsession = {
    enable = false;
  };

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox;
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-websocket
      ];
    };

    chromium = {
      enable = true;
      package = pkgs.unstable.google-chrome;
    };
  };
}
