{
  config,
  pkgs,
  ...
}: {
  # home config example
  home.username = "exec";
  home.homeDirectory = "/home/exec";
  home.stateVersion = "23.05";

  home.packages = [
    pkgs.alacritty
    pkgs.alejandra
    pkgs.atool
    pkgs.bat
    pkgs.cargo-expand
    pkgs.cmake
    pkgs.copyq
    pkgs.cpupower-gui
    pkgs.delta
    pkgs.dig
    pkgs.fd
    pkgs.flameshot
    pkgs.fzf
    pkgs.gh
    pkgs.grc
    pkgs.htop
    pkgs.httpie
    pkgs.jq
    pkgs.kitty
    pkgs.kitty-themes
    pkgs.libstdcxx5
    pkgs.mlocate
    pkgs.mold
    pkgs.mpv
    pkgs.neovide
    pkgs.powertop
    pkgs.ripgrep
    pkgs.rust-analyzer
    pkgs.rustup
    pkgs.sccache
    pkgs.spotify
    pkgs.tmux
    pkgs.variety
    pkgs.wakatime
    pkgs.xclip
    pkgs.zsh
    pkgs.zsh-powerlevel10k
    pkgs.vimpager
    pkgs.most
    pkgs.inetutils
    pkgs.du-dust

    pkgs.emacsPackages.telega
    pkgs.emacsPackages.vterm

    pkgs.proxychains-ng

  ];

  programs.home-manager.enable = true;
}
