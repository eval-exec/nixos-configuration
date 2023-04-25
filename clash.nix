{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf (config.networking.hostName == "Mufasa") {
  systemd.services.clash = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "Start the Clash.";
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = ''/home/exec/.config/clash/clash-premium -d /home/exec/.config/clash'';
    };
  };
}
