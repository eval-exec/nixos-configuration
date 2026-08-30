{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.users) primaryUser;
in
{
  options.users.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "The local user that owns the interactive configuration.";
  };

  config = {
    security = {
      wrappers = {
        criu = {
          owner = primaryUser;
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

    users.users.${primaryUser} = {
      isNormalUser = true;
      description = primaryUser;
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
  };
}
