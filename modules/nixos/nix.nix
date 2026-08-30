{
  config,
  inputs,
  lib,
  ...
}:
{
  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
      inputs.self.overlays.emacs-overlay
      inputs.nix-alien.overlays.default
      inputs.nix-cachyos-kernel.overlays.pinned

    ];
    config = {
      allowUnfree = true;
      cudaSupport = false;
      permittedInsecurePackages = [
        "electron-11.5.0"
        "electron-24.8.6"
        "electron-25.9.0"
        "electron-19.1.9"
        "electron-28.3.3"
        "electron-27.3.11"
        "electron-32.3.3"
        "electron-39.8.10"
      ];
      vivaldi = {
        proprietaryCodecs = true;
        enableWideVine = true;
      };
      nvidia.acceptLicense = true;

    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      gc = {
        automatic = true;
        dates = "weekly";
      };

      distributedBuilds = true;
      settings = {

        builders-use-substitutes = true;

        auto-optimise-store = true;
        trusted-users = [
          "root"
          config.users.primaryUser
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];

        substituters = [
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://mirrors.ustc.edu.cn/nix-channels/store"
          "https://mirror.nju.edu.cn/nix-channels/store"
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://devenv.cachix.org"
          "https://attic.xuyh0120.win/lantian"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "";
        nix-path = config.nix.nixPath;
      };
      channel.enable = false;

      registry.nixpkgs.flake = inputs.nixpkgs;
      registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

}
