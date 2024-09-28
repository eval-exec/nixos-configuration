{
  description = "Eval EXEC's NixOS flake";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
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
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      # packages.x86_64-linux = [
      # ];

      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      # homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        Mufasa = nixpkgs.lib.nixosSystem {

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.exec = import ./home-manager/home.nix;
            }
          ];
        };
      };

      # nixosConfigurations.Mufasa = nixpkgs.lib.nixosSystem {
      #   specialArgs = {
      #     inherit inputs outputs;
      #   };
      # system = "x86_64-linux";
      # specialArgs = {
      #   pkgs-unstable = import nixpkgs-unstable {
      #     inherit system;
      #     config = {
      #       allowUnfree = true;
      #     };
      #   };
      #   inherit
      #     nixpkgs
      #     home-manager
      #     emacs-overlay
      #     nixpkgs-unstable
      #     sops-nix
      #     nur
      #     ;
      # };
      # modules = [
      #   ./nixos/hardware-configuration.nix
      # nur.nixosModules.nur
      # sops-nix.nixosModules.sops
      # home-manager.nixosModules.home-manager
      # {
      #   home-manager.useGlobalPkgs = true;
      #   home-manager.useUserPackages = true;
      #   home-manager.users.exec = import ./home.nix;
      #   home-manager.extraSpecialArgs = specialArgs;
      #   nixpkgs.overlays = [
      #     nur.overlay
      #     emacs-overlay.overlay
      #   ];

      #   # Optionally, use home-manager.extraSpecialArgs to pass
      #   # arguments to home.nix
      # }
      # ];
      # };
    };
}
