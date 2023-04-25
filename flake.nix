{
  description = "Eval EXEC's NixOS flake";


  outputs = {
    self,
    nixpkgs,
  }: {
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfigurations.Mufasa = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
      ./hardware-configuration.nix
      ./configuration.nix
      ./home.nix
      ];
    };
  };
}
