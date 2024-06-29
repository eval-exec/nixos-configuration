{
  description = "Eval EXEC's NixOS flake";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-vmware.url = "github:nixos/nixpkgs?rev=69906365e06c43d5b5fe9e63a0477c8686fe6b34";
    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-vmware,
      nur,
      home-manager,
      emacs-overlay,
      sops-nix,
      ...
    }:
    {
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      # packages.x86_64-linux = [
      # ];

      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

      nixosConfigurations.Mufasa = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {

          pkgs-stable = import nixpkgs-stable {
            # Refer to the `system` parameter from
            # the outer scope recursively
            inherit system;
            # To use Chrome, we need to allow the
            # installation of non-free software.
            config.allowUnfree = true;
          };

          pkgs-vmware = import nixpkgs-vmware {
            # Refer to the `system` parameter from
            # the outer scope recursively
            inherit system;
            # To use Chrome, we need to allow the
            # installation of non-free software.
            config.allowUnfree = true;
          };

          inherit
            nixpkgs
            nixpkgs-stable
            home-manager
            emacs-overlay
            sops-nix
            nur
            ;
        };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.exec = import ./home.nix;
            # home-manager.extraSpecialArgs = { inherit config; };
            nixpkgs.overlays = [
              nur.overlay
              emacs-overlay.overlay
            ];

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
