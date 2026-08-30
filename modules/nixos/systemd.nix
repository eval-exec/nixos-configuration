{ pkgs, ... }:
{
  systemd.services.sunshine = {
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      User = "root";
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
    };
  };
}
