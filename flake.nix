{
  description = "NixOS configuration for Mufasa";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    fcitx5-vinput.url = "github:xifan2333/fcitx5-vinput";

    grok-bot-flake = {
      url = "github:jordangarrison/grok-bot-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://fcitx5-vinput.cachix.org" ];
    extra-trusted-public-keys = [
      "fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="
    ];
  };

  outputs =
    inputs@{
      home-manager,
      nixpkgs,
      sops-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = import ./pkgs pkgs;
      formatter.${system} = pkgs.nixfmt;

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations.Mufasa = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/Mufasa
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
        ];
      };
    };
}
