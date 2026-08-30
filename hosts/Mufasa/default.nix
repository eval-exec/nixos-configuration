{ config, inputs, ... }:
let
  inherit (config.users) primaryUser;
in
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
  users.primaryUser = "exec";

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs primaryUser; };
    users.${primaryUser} = import ../../homes/exec;
  };
}
