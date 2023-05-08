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
    pkgs.lm_sensors

    pkgs.emacsPackages.telega
    pkgs.emacsPackages.vterm

    pkgs.wofi
    pkgs.dolphin
    pkgs.g810-led
    pkgs.direnv
    pkgs.yt-dlp
    pkgs.dmidecode
    pkgs.unzip
    pkgs.logseq
    pkgs.zsh-autosuggestions
  ];
  programs = {
    home-manager.enable = true;
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      initExtra = ''
          # Preview file content using bat (https://github.com/sharkdp/bat)
                export FZF_CTRL_T_OPTS="
                --preview 'bat -n --color=always {}'
                --bind 'ctrl-/:change-preview-window(down|hidden|)'"
          # CTRL-/ to toggle small preview window to see the full command
          # CTRL-Y to copy the command into clipboard using pbcopy
                export FZF_CTRL_R_OPTS="
                --preview 'echo {}' --preview-window up:3:hidden:wrap
                --bind 'ctrl-/:toggle-preview'
                --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
                --color header:italic
                --header 'Press CTRL-Y to copy command into clipboard'"
          # Print tree structure in the preview window
                export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
                NPM_CONFIG_PREFIX=~/.npm-global

        export ZSH_WAKATIME_PROJECT_DETECTION=true
      '';

      shellAliases = {
        ll = "ls -l";
        cat = "bat -p";
        vim = "lvim";
        update = "sudo nixos-rebuild switch";
      };
      # 	history = {
      # 		size = 1000000;
      # 		path = "${config.xdg.dataHome}/zsh/history";
      # 	};
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "fzf"
          "man"
          "grc"
          "zsh-wakatime"
          "fzf-tab"
        ];
        # theme = "mlh";
        custom = "/home/exec/.oh-my-zsh/custom";
      };
    };
  };
}
