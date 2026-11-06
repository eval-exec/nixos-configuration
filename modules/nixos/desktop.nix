{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Boot to the text console; start SDDM on demand with
  # `systemctl start display-manager.service`.
  systemd.defaultUnit = lib.mkForce "multi-user.target";
  # Keep SDDM installed but still start kmscon on tty1 at boot.
  systemd.targets.getty.wants = lib.mkIf config.services.kmscon.enable (
    lib.mkForce [ "kmsconvt@tty1.service" ]
  );

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  specialisation = {
    tty = {
      configuration = {
        services = {
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

    touchegg = {
      enable = false;
    };

    displayManager = {
      enable = true;
      defaultSession = "plasma";
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
