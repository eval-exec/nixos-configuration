{ primaryUser, ... }:
{
  imports = [
    ../../modules/home/packages.nix
    ../../modules/home/environment.nix
    ../../modules/home/mail.nix
    ../../modules/home/desktop.nix
    ../../modules/home/development.nix
    ../../modules/home/shell.nix
    ../../modules/home/services/network.nix
    ../../modules/home/services/session.nix
  ];

  home = {
    username = primaryUser;
    homeDirectory = "/home/${primaryUser}";
    stateVersion = "26.05";
  };
}
