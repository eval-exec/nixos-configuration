{
  config,
  pkgs,
  ...
}:
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.home.homeDirectory}/Projects/github.com/eval-exec/nixos-configuration";
  };

  programs = {
    bacon.enable = true;

    vscode = {
      enable = true;
      package = pkgs.unstable.vscode.fhs;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    go = {
      enable = true;
    };
    eza = {
      enable = true;
      icons = "auto";
    };

    java = {
      enable = true;
      package = pkgs.jdk21;
    };
  };
}
