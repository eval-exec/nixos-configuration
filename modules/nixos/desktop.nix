{
  config,
  lib,
  pkgs,
  ...
}:
{
  specialisation = {
    tty = {
      configuration = {
        services = {
          displayManager.sddm.enable = lib.mkForce false;
          desktopManager.plasma6.enable = lib.mkForce false;
          flatpak.enable = lib.mkForce false;
          xserver.enable = lib.mkForce false;
        };
      };
    };
  };

  services = {
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

    touchegg = {
      enable = false;
    };

    displayManager = {
      enable = true;
      ly = {
        enable = false;
      };

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

    printing.enable = false;
  };
}
