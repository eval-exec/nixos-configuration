_: {
  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;

    docker = {
      enable = true;

    };
    podman = {
      enable = true;

      dockerCompat = false;

      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
