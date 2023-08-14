{ config, pkgs, ... }: {
  # home config example
  home.username = "exec";
  home.homeDirectory = "/home/exec";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    alacritty
    alejandra
    wmctrl
    xdotool
    peek
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gifski
    pipenv
    wineWowPackages.stable
    winetricks
    bitcoin
    iftop
    cool-retro-term
    moreutils
    jetbrains.clion
    jetbrains.goland
    atool
    babashka
    bat
    clj-kondo
    clojure
    clojure-lsp
    cmake
    copyq
    cpupower-gui
    delta
    dig
    direnv
    dmidecode
    dolphin
    du-dust
    emacsPackages.telega
    emacsPackages.vterm
    exercism
    fd
    ffmpeg-full
    flameshot
    fzf
    g810-led
    gh
    ghostie
    github-desktop
    go-ethereum
    google-chrome-dev
    grc
    htop
    httpie
    intel-gpu-tools
    hugo
    inetutils
    jetbrains.idea-ultimate
    joker
    jq
    kitty
    kitty-themes
    leiningen
    amdgpu_top
    lshw
    xorg.xdpyinfo
    xorg.xmodmap
    cloudflared
    ddcui
    ddcutil
    libfaketime
    libstdcxx5
    llvmPackages.libcxx
    llvmPackages.libcxxClang
    lm_sensors
    logseq
    mercurial
    microsoft-edge-dev
    mlocate
    mold
    most
    mpv
    ncurses
    neovide
    ninja
    nixfmt
    pastebinit
    patchelf
    pkgconfig
    powershell
    powertop
    protobuf
    qbittorrent
    qrcp
    ripgrep
    sccache
    sioyek
    lsof
    spotify
    sysstat
    tmux
    typos
    unzip
    vagrant
    autoconf
    automake
    variety
    vimpager
    wakatime
    wezterm
    wofi
    xclip
    yt-dlp
    zlib
    zsh
    zsh-autosuggestions
    zsh-powerlevel10k
    zulip
  ];
  home.file.".emacs.d/early-init.el" = { source = ./emacs-early-init.el; };
  home.file.".emacs.d/init.el" = { source = ./emacs-init.el; };

  home.sessionPath = [

    "/home/exec/.cargo/bin"
  ];

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
    thunderbird = {
      enable = true;
      profiles = { exec = { isDefault = true; }; };
    };
    go = {
      enable = true;

    };
    exa = {
      enable = true;
      enableAliases = true;
      icons = true;
      # extraOptions = [];
    };

    java = { enable = true; };
    emacs = {
      enable = true;
      package = pkgs.emacs-git;
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
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


        zstyle ':bracketed-paste-magic' active-widgets '.self-*'

      '';
      envExtra = ''
        export NIXPKGS_ALLOW_UNFREE=1;

      '';

      shellAliases = {
        cat = "bat -p";
        vim = "lvim";
        update = "sudo nixos-rebuild switch";
        emacs = "emacsclient -nw";
      };
      history = {
        size = 10000000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins =
          [ "git" "fzf" "man" "warhol" "zsh-wakatime" "fzf-tab" "nix-shell" ];
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
        git_status = { disabled = true; };
      };
    };
  };
  systemd.user.services = {
    clash = {
      Unit = { Description = "clash"; };
      Service = {
        ExecStart =
          "/home/exec/.config/clash/clash-premium -d /home/exec/.config/clash";
        Restart = "always";
        WantedBy = [ "network-online.target" ];
      };
    };
  };
}
