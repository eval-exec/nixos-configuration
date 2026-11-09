{ primaryUser, inputs, ... }:
{
  imports = [
    inputs.nix-index-database.homeModules.default
    ../../modules/home/packages.nix
    ../../modules/home/environment.nix
    ../../modules/home/mail.nix
    ../../modules/home/desktop.nix
    ../../modules/home/codex-desktop.nix
    ../../modules/home/development.nix
    ../../modules/home/shell.nix
    ../../modules/home/services/network.nix
    ../../modules/home/services/session.nix
    ../../modules/home/services/input-method.nix
    ../../modules/home/services/gpg-agent.nix
  ];

  # User-level Nix client settings. The system-wide equivalents live in
  # modules/nixos/nix.nix; this adds the extra caches used by the overlay.
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.nju.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      "https://cache.lantian.pub/lantian"
      "https://chaotic-nyx.cachix.org"
      "https://nix-wpe-webkit.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-wpe-webkit.cachix.org-1:ItCjHkz1Y5QcwqI9cTGNWHzcox4EqcXqKvOygxpwYHE="
    ];
  };

  home = {
    username = primaryUser;
    homeDirectory = "/home/${primaryUser}";
    stateVersion = "26.05";
  };
}
