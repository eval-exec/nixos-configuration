{ config, pkgs, ... }:
let
  primaryUser = config.users.primaryUser;
  loginctl = "${config.systemd.package}/bin/loginctl";

  # runuser does not set XDG_RUNTIME_DIR, and the primary user's UID is
  # assigned at activation time, so resolve it when the key is pressed.
  userEnv = pkgs.writeShellScript "media-key-user-env" ''
    export XDG_RUNTIME_DIR="/run/user/$(${pkgs.coreutils}/bin/id -u)"
    exec "$@"
  '';

  asUser = cmd: "${pkgs.util-linux.bin}/bin/runuser -u ${primaryUser} -- ${userEnv} ${cmd}";

  # Only act when the active VT is a text console. When KDE owns the active
  # VT, Plasma's global shortcuts already handle these media keys.
  textVtOnly = pkgs.writeShellScript "text-vt-media-key" ''
    read -r active < /sys/class/tty/tty0/active
    while read -r session _; do
      tty="$(${loginctl} show-session "$session" -p TTY --value 2>/dev/null)"
      [ "$tty" = "$active" ] || continue
      case "$(${loginctl} show-session "$session" -p Type --value 2>/dev/null)" in
        wayland|x11) exit 0 ;;
      esac
    done < <(${loginctl} list-sessions --no-legend)
    exec "$@"
  '';
in
{
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  services = {
    # KDE's Power Management (Powerdevil) drives the power profiles through
    # power-profiles-daemon, which owns the CPU governor, EPP and ACPI
    # platform_profile. Don't set cpuFreqGovernor or platform_profile here --
    # a static governor or an acpid handler would fight it.
    power-profiles-daemon.enable = true;

    triggerhappy = {
      enable = true;
      user = "root";
      bindings = [
        {
          keys = [ "MUTE" ];
          cmd = "${textVtOnly} ${asUser "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"}";
        }
        {
          keys = [ "VOLUMEUP" ];
          cmd = "${textVtOnly} ${asUser "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"}";
        }
        {
          keys = [ "VOLUMEDOWN" ];
          cmd = "${textVtOnly} ${asUser "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"}";
        }
        {
          keys = [ "PLAYPAUSE" ];
          cmd = "${textVtOnly} ${asUser "${pkgs.mpc}/bin/mpc -q toggle"}";
        }
        {
          keys = [ "NEXTSONG" ];
          cmd = "${textVtOnly} ${asUser "${pkgs.mpc}/bin/mpc -q next"}";
        }
        {
          keys = [ "PREVIOUSSONG" ];
          cmd = "${textVtOnly} ${asUser "${pkgs.mpc}/bin/mpc -q prev"}";
        }
        {
          keys = [ "BRIGHTNESSUP" ];
          cmd = "${textVtOnly} ${pkgs.brightnessctl}/bin/brightnessctl -q set 5%+";
        }
        {
          keys = [ "BRIGHTNESSDOWN" ];
          cmd = "${textVtOnly} ${pkgs.brightnessctl}/bin/brightnessctl -q set 5%-";
        }
      ];
    };

    logind.settings.Login = {
      RuntimeDirectorySize = "16G";
    };

    thermald.enable = false;
    thermald.debug = false;
  };
}
