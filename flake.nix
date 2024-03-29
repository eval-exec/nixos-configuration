{
  description = "Eval EXEC's NixOS flake";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    flake-utils = { url = "github:numtide/flake-utils"; };
    sops-nix = { url = "github:Mic92/sops-nix"; };
    home-manager = { url = "github:nix-community/home-manager"; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; };
  };

  outputs =
    { self, nixpkgs, nur, home-manager, emacs-overlay, sops-nix, ... }: {
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      # packages.x86_64-linux = [
      # ];

      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

      nixosConfigurations.Mufasa = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit nixpkgs home-manager emacs-overlay sops-nix nur;
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
            nixpkgs.overlays = [ nur.overlay emacs-overlay.overlay ];

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
