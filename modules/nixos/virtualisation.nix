_: {
  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;

    virtualbox = {
      host = {
        enable = false;
      };
      guest.enable = false;
    };
    docker = {
      enable = true;

    };
    podman = {
      enable = true;

      dockerCompat = false;

      defaultNetwork.settings.dns_enabled = true;
    };
    vmware = {
      host = {
        enable = false;
      };
    };
  };
}
