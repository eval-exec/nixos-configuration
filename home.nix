{ config, pkgs, inputs, lib, ... }: {
  # home config example

  home.username = "exec";
  home.homeDirectory = "/home/exec";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    alacritty
    alejandra
    gdb
    gf
    qtcreator
    github-copilot-cli

    qt6.full
    qt6.qtbase
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
    sops
    clojure
    clojure-lsp
    cmake
    copyq
    cpupower-gui
    delta
    dig
    direnv
    dmidecode
    element-desktop
    silver-searcher
    pharo
    dolphin
    helix
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
    yq
    kitty
    kitty-themes
    leiningen
    amdgpu_top
    lshw
    # nodePackages.parcel
    calibre

    xorg.xwininfo
    vlc
    mu
    meson
    xorg.xdpyinfo
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xmodmap
    xorg.libxcb
    xorg.xcbutil
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
    isync
    goimapnotify
    zulip
  ];
  home.file.".emacs.d/early-init.el" = { source = ./emacs-early-init.el; };
  home.file.".emacs.d/init.el" = { source = ./emacs-init.el; };

  home.sessionPath = [

    "/home/exec/.cargo/bin"
  ];

  accounts = {
    email = {
      accounts = {
        execvy = {
          primary = true;
          realName = "Eval EXEC";
          address = "execvy@gmail.com";
          userName = "execvy@gmail.com";
          flavor = "gmail.com";
          folders = {
            drafts = "Drafts";
            inbox = "Inbox";
            sent = "Sent";
            trash = "Trash";
          };
          gpg = { key = "4B453CE70F2646044171BACE0F0272C0D3AC91F7"; };
          passwordCommand = "cat /home/exec/pass/gapp.txt";
          imap = {
            host = "imap.gmail.com";
            port = 993;
            tls = { enable = true; };
          };
          imapnotify = {
            enable = false;
            boxes = [ "INBOX" ];
            # extraConfig = { wait = 1; };
            onNotify = "${pkgs.isync}/bin/mbsync --pull execvy:INBOX";
            # onNotifyPost = "${pkgs.mu}/bin/mu index";
            onNotifyPost =
              "${pkgs.emacs-git}/bin/emacsclient -e '(mu4e-update-index)'";
          };

          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
            extraConfig = {
              account = {

              };
              channel = { MaxMessages = 200; };
              local = { };
              remote = { };

            };
            patterns = [ "*" ];
            remove = "both";
            subFolders = "Verbatim";
          };
          msmtp = { enable = true; };
          # smtp = { host = "gmail.com"; };
          mu = { enable = true; };

        };

      };

    };
  };

  services = {
    imapnotify = { enable = true; };
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    mbsync = {
      enable = true;
      # frequency = "*-*-* *:*:00,20,40";
      postExec = "${pkgs.mu}/bin/mu index";
      verbose = true;
    };
  };
  programs = {
    home-manager.enable = true;
    mbsync = { enable = true; };
    msmtp = { enable = true; };
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
      package = (pkgs.emacs-git.override { withGTK3 = true; });
      extraPackages = epkgs: [ pkgs.mu ];
    };
    offlineimap = {
      enable = false;
      # extraConfig = {
      #   default = {
      #   };
      #   general = {
      #   };
      # };

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

        setopt NO_HUP

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
  # systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  # systemd.users.services.mbsync.serviceConfig.SupplementaryGroups =
  #   [ config.users.groups.keys.name ];

  systemd.user.services = {
    clash = {
      Unit = { Description = "clash"; };
      Service = {
        ExecStart =
          "/home/exec/.config/clash/clash-premium -d /home/exec/.config/clash";
        Restart = "always";
        AfterBy = [ "network-online.target" ];
      };
    };
  };
}
