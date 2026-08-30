{ config, pkgs, ... }:
{
  systemd.user = {
    startServices = "sd-switch";
    services = {
      clash = {
        Unit = {
          Description = "clash";
          X-SwitchMethod = "keep-old";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStart = "${config.home.homeDirectory}/.config/clash/clash-premium -d ${config.home.homeDirectory}/.config/clash";
        };
      };

      matrix = {
        Unit = {
          Description = "matrix";
          X-SwitchMethod = "keep-old";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStartPre = "${pkgs.bash}/bin/bash -c 'until ${pkgs.iputils}/bin/ping -c1 bing.com; do ${pkgs.coreutils}/bin/sleep 1; done;'";
          ExecStart = "${pkgs.openssh}/bin/ssh -o ConnectTimeout=2 -n matrix_wan uptime && sleep infinity";
          RestartSec = 3;
          Restart = "always";
        };
      };

      matrix_port_forward = {
        Unit = {
          Description = "matrix port formward";
          X-SwitchMethod = "keep-old";
          Wants = [ "network-online.target" ];
          After = [
            "network-online.target"
            "matrix.service"
          ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          Restart = "always";
          RestartSec = 3;
          ExecStart = "${pkgs.openssh}/bin/ssh -S none -N -T -L 3000:127.0.0.1:3000 -L 9090:127.0.0.1:9090 -L 8899:127.0.0.1:8899 -L 48080:127.0.0.1:48080 -L 58080:127.0.0.1:8080 -L 11434:127.0.0.1:11434 -L 27631:127.0.0.1:27631 matrix_wan";
        };
      };
    };
  };
}
