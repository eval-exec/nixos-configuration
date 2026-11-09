{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  specialisation = {
    tty = {
      configuration = {
        # Text-only rescue entry: kmscon on tty1, no display manager.
        systemd.defaultUnit = lib.mkForce "multi-user.target";
        services = {
          displayManager.enable = lib.mkForce false;
          displayManager.sddm.enable = lib.mkForce false;
          displayManager.defaultSession = lib.mkForce null;
          desktopManager.plasma6.enable = lib.mkForce false;
          flatpak.enable = lib.mkForce false;
          xserver.enable = lib.mkForce false;
        };
      };
    };
  };

  services = {
    upower.enable = true;

    desktopManager = {
      plasma6.enable = true;
    };

    flatpak = {
      enable = true;
    };
    guix = {
      package = pkgs.unstable.guix;
      enable = true;
    };
    fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };

    displayManager = {
      enable = true;
      defaultSession = "plasma";

      sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = true;
        wayland.compositor = "kwin";
      };
      autoLogin = {
        enable = false;
        user = config.users.primaryUser;
      };
    };

    libinput = {
      enable = true;
      touchpad = {
        accelProfile = "flat";
        accelSpeed = "0.5";
      };
    };

    xserver = {
      enable = true;
      xkb = {
        options = "ctrl:hyper_capscontrol";
      };

      videoDrivers = [
        "modesetting"
        "nvidia"
      ];
    };
  };
}
