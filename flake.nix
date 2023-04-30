{
  description = "Eval EXEC's NixOS flake";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-software-center.url = "github:vlinkz/nix-software-center";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-software-center,
    ...
  }: {
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfigurations.Mufasa = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.exec = import ./home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }

        {
          nixpkgs.overlays = [
            (import (builtins.fetchTarball {
              url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
              sha256 = "1fjjh69z82a1lj4p0psn4jm6yqms2jjb5fvc1wfv8bmx5kahywc1";
            }))
          ];
        }
      ];
    };
  };
}
