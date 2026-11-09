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

    # The lock currently pins the revision whose prebuilt database is in the
    # store; refresh with `nix flake update nix-index-database` once GitHub
    # release downloads are reachable.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    grok-bot-flake = {
      url = "github:jordangarrison/grok-bot-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
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
      plainPkgs = nixpkgs.legacyPackages.${system};
      packageSet = import ./overlays/package-set.nix { inherit inputs; };
      pkgs = import nixpkgs {
        inherit system;
        overlays = packageSet.pkgsOverlays;
        inherit (packageSet) config;
      };
    in
    {
      packages.${system} = import ./pkgs plainPkgs;
      formatter.${system} = plainPkgs.nixfmt;

      overlays = packageSet.overlays;

      nixosConfigurations.Mufasa = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/Mufasa
          { nixpkgs.pkgs = pkgs; }
          sops-nix.nixosModules.sops
        ];
      };

      # Standalone. A switch writes the home and stays there across reboot.
      # The NixOS module service is what used to replace it on boot.
      homeConfigurations.exec = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          primaryUser = "exec";
        };
        modules = [ ./homes/exec ];
      };
    };
}
