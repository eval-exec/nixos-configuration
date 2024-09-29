{
  home.file.".tmux.conf" = {
    enable = true;
    source = ./tmux/tmux.conf.nix;
  };

  home.file.".tmux.conf.local" = {
    enable = true;
    source = ./tmux/tmux.conf.local.nix;
  };
}
