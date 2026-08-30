{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/virtualisation.nix
    ../../modules/nixos/environment.nix
    ../../modules/nixos/programs.nix
    ../../modules/nixos/systemd.nix
  ];

  networking.hostName = "Mufasa";
  system.stateVersion = "26.05";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.exec = import ../../homes/exec;
  };
}
