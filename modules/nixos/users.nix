{ pkgs, ... }:
{
  security = {
    wrappers = {
      criu = {
        owner = "exec";
        group = "users";
        capabilities = "cap_checkpoint_restore+eip";
        source = "${pkgs.criu}/bin/criu";
      };
    };
    rtkit.enable = true;
    pam.services.sddm.enableKwallet = true;
    pam.services.kdewallet = {
      name = "kdewallet";
      enableKwallet = true;
    };
  };

  users.users.exec = {
    isNormalUser = true;
    description = "exec";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "kvm"
      "libvirtd"
      "ydotool"
      "vboxusers"
      "video"
      "render"
    ];
    packages = with pkgs; [
      firefox
    ];
  };
  users.defaultUserShell = pkgs.zsh;
}
