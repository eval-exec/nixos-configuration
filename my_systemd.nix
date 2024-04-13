{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf (config.networking.hostName == "Mufasa") {
  systemd.services.clash = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    description = "Start the Clash.";
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = "/home/exec/.config/clash/clash-premium -d /home/exec/.config/clash";
    };
  };

  systemd.services.disable_cpu_turbo = {
    wantedBy = [ "multi-user.target" ];
    description = "Disable Intel CPU Turbo";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = ''/bin/sh -c "echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
      ExecStop = ''/bin/sh -c "echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
      RemainAfterExit = true;
    };
  };
}
