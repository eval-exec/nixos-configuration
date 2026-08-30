{ lib, ... }:
{
  networking = {
    extraHosts = ''
      127.0.0.1 localhost
    '';

    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = false;
      wifi.backend = "wpa_supplicant";
      logLevel = "INFO";
      dispatcherScripts = [
        {
          source = ./network-dispatcher.sh;
          type = "basic";
        }

      ];
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "2606:4700:4700::1111"
    ];
    firewall = {
      enable = false;
    };
  };

  services.tailscale.enable = true;
  systemd.services.NetworkManager-dispatcher.enable = lib.mkForce false;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
