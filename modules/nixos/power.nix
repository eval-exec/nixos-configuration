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
    power-profiles-daemon.enable = false;

    acpid = {
      enable = true;
      logEvents = true;
      acEventCommands = ''
                echo AC adapter event: $1
                vals=($1)  # space separated string to array of multiple values
                case ''${vals[3]} in
                  00000001)
                    echo plugged in
                    ${pkgs.linuxPackages.cpupower}/bin/cpupower frequency-set -g performance
                    ${pkgs.linuxPackages.cpupower}/bin/cpupower set all -b 0 --epp performance
        	    echo performance > /sys/firmware/acpi/platform_profile
                    ;;
                  00000000)
                    echo unplugged
                    ${pkgs.linuxPackages.cpupower}/bin/cpupower frequency-set -g powersave
                    ${pkgs.linuxPackages.cpupower}/bin/cpupower set all -b 15 --epp power
                    echo disable turbo...
                    echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
        	    echo quiet > /sys/firmware/acpi/platform_profile
                    echo disable turbo done
                    ;;
                  *)
                    echo unknown acpi event
                    ;;
                esac
      '';
    };

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
