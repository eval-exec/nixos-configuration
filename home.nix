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
    pkgs.microsoft-edge-dev
    pkgs.alejandra
    pkgs.jetbrains.idea-ultimate
    pkgs.atool
    pkgs.bat
    pkgs.cargo-expand
    pkgs.cargo-machete
    pkgs.cmake
    pkgs.copyq
    pkgs.cpupower-gui
    pkgs.delta
    pkgs.dig
    pkgs.direnv
    pkgs.dmidecode
    pkgs.dolphin
    pkgs.du-dust
    pkgs.emacsPackages.telega
    pkgs.emacsPackages.vterm
    pkgs.fd
    pkgs.flameshot
    pkgs.fzf
    pkgs.g810-led
    pkgs.gh
    pkgs.grc
    pkgs.google-chrome-dev
    pkgs.htop
    pkgs.httpie
    pkgs.hugo
    pkgs.inetutils
    pkgs.leiningen
    pkgs.clojure
    pkgs.clojure-lsp
    pkgs.clj-kondo
    pkgs.babashka
    pkgs.joker
    pkgs.protobuf
    pkgs.jq
    pkgs.kitty
    pkgs.kitty-themes
    pkgs.libstdcxx5
    pkgs.lm_sensors
    pkgs.logseq
    pkgs.mlocate
    pkgs.mold
    pkgs.most
    pkgs.mpv
    pkgs.neovide
    pkgs.pastebinit
    pkgs.powershell
    pkgs.llvmPackages.libcxxClang
    pkgs.llvmPackages.libcxx
    pkgs.mercurial
    pkgs.typos
    pkgs.powertop
    pkgs.ripgrep
    pkgs.rustup
    pkgs.sccache
    pkgs.spotify
    pkgs.ffmpeg-full
    pkgs.exercism
    pkgs.tmux
    pkgs.unzip
    pkgs.variety
    pkgs.vimpager
    pkgs.wakatime
    pkgs.wofi
    pkgs.xclip
    pkgs.yt-dlp
    pkgs.zsh
    pkgs.sioyek
    pkgs.zsh-autosuggestions
    pkgs.zsh-powerlevel10k
    pkgs.libfaketime
    pkgs.qrcp
    pkgs.qbittorrent
    pkgs.ninja
    pkgs.sysstat
    pkgs.github-desktop
    pkgs.ghostie
  ];
  home.file.".emacs.d/early-init.el" = {source = ./emacs-early-init.el;};
  home.file.".emacs.d/init.el" = {source = ./emacs-init.el;};
  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
  programs = {
    home-manager.enable = true;
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    java = {
      enable = true;
    };
    emacs = {
      enable = true;
      package = pkgs.emacsGit;
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      initExtra = ''
        # Preview file content using bat (https://github.com/sharkdp/bat)
        export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
        # CTRL-/ to toggle small preview window to see the full command
        # CTRL-Y to copy the command into clipboard using pbcopy
        export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
        # Print tree structure in the preview window
        export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
        NPM_CONFIG_PREFIX=~/.npm-global

        export ZSH_WAKATIME_PROJECT_DETECTION=true
        export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib";
        zstyle ':completion:*' sort false
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':fzf-tab:*' prefix ' '

        zstyle ':fzf-tab:*' switch-group ',' '.'

      '';

      shellAliases = {
        ll = "ls -l";
        cat = "bat -p";
        vim = "lvim";
        update = "sudo nixos-rebuild switch";
        emacs = "emacsclient -nw";
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
    bash = {
      enable = false;
      enableCompletion = false;
      enableVteIntegration = true;
      historyFile = "/home/exec/.bash_history";
      initExtra = ''
        # Preview file content using bat (https://github.com/sharkdp/bat)
        export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
        # CTRL-/ to toggle small preview window to see the full command
        # CTRL-Y to copy the command into clipboard using pbcopy
        export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
        # Print tree structure in the preview window
        export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
        export NPM_CONFIG_PREFIX=~/.npm-global
        export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib";
      '';
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        add_newline = false;
        command_timeout = 200;
        git_status = {
          disabled = true;
        };
      };
    };
  };
}
