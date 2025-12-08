# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    outputs.homeManagerModules.bacon
    outputs.homeManagerModules.tmux

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  # home-manager.backupFileExtension = "hm-backup";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      nvidia.acceptLicense = true;
      # Disable if you don't want unfree packages
      allowUnfree = true;
      cudaSupport = false;
      permittedInsecurePackages = [
        "electron-27.3.11"
        "electron-32.3.3"
      ];

    };
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.username = "exec";
  home.homeDirectory = "/home/exec";
  home.stateVersion = "25.11";
  # home.pointerCursor = {
  #   package = pkgs.gnome.gnome-themes-extra;
  #   name = "Breeze";
  #   size = 24;
  #   gtk.enable = true;
  # };

  home.packages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "watchman";
      paths = [ pkgs.watchman ];
      nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/watchman" --set TMPDIR /tmp/watchman_tmp
      '';
    })
    # beets
    # github-copilot-cli
    # github-desktop
    # graalvm-ce
    # inputs.claude-desktop.packages.x86_64-linux.claude-desktop-with-fhs
    # inputs.ghostty.packages.x86_64-linux.default
    # inputs.quickshell.packages.x86_64-linux.default
    # ionshare
    # jetbrains.clion
    # jetbrains.goland
    # jetbrains.idea-ultimate
    # linux-manual
    # microsoft-edge-dev
    # nur.repos.linyinfeng.wemeet
    # nur.repos.xddxdd.baidunetdisk
    # nur.repos.xddxdd.netease-cloud-music
    # nur.repos.xddxdd.qqmusic
    # nur.repos.xddxdd.wechat-uos
    # spotdl
    # tigervnc
    # unstable.davinci-resolve
    # unstable.ghostty
    # unstable.nyxt
    # unstable.vagrant
    # unstable.whisper-ctranslate2
    # unstable.zed-editor # I installed zed by https://zed.dev/install.sh | ZED_CHANNEL=preivew sh
    # vivaldi
    # vivaldi-ffmpeg-codecs
    # webkitgtk
    # wpewebkit
    age
    aileron
    alacritty
    alejandra
    alsa-utils
    amdgpu_top
    android-tools
    ascii
    asciidoc
    ast-grep
    at
    atool
    autoconf
    automake
    autotools-language-server
    awscli2
    bat
    bats
    bc
    bear
    bison
    bitcoin
    blender
    bottles
    brave
    brightnessctl
    browsh
    btop
    bun
    calibre
    ccls
    chafa
    chromaprint
    chromium
    clinfo
    clj-kondo
    cljfmt
    clojure
    clojure-lsp
    cloudflared
    cmake
    comma
    cool-retro-term
    # copyq
    foliate
    gopass
    gflags
    rocksdb.tools
    coreutils-full
    cppcheck
    cpulimit
    crate2nix
    ddcui
    ddcutil
    delta
    deno
    desktop-file-utils
    devbox
    difftastic
    dig
    discord
    distcc
    distrobox
    dive
    dmidecode
    dpkg
    droidcam
    dust
    dwarf-fortress
    element-desktop
    epubcheck
    errcheck
    evtest
    exercism
    extra-cmake-modules
    fastfetch
    fd
    ffmpeg-full
    fftw
    firefoxpwa
    fish
    flameshot
    flatpak-builder
    fpp
    fuse
    fuse3
    fuzzel
    gdb
    gettext
    gf
    gh
    gh-dash
    ghostie
    gifski
    gimp
    gitstatus
    glibc_multi
    mesa-demos
    gnuplot
    gnutls
    go-ethereum
    go2tv
    goimapnotify
    golangci-lint
    google-cloud-sdk
    gperf
    gptcommit
    graphviz
    grc
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    gtest
    gthumb
    guile
    helix
    httpie
    hugo
    iftop
    imagemagick
    inetutils
    inotify-info
    inotify-info
    inotify-tools
    inotify-tools
    intel-gpu-tools
    iotop
    ipfs
    jemalloc
    joker
    jq
    just
    kanshi
    kdePackages.dolphin
    kew
    keyd
    kitty
    kitty-themes
    kodi
    lazygit
    leiningen
    lf
    libcamera
    libfaketime
    libnotify
    libressl
    libva-utils
    llvmPackages.libcxx
    llvmPackages.libcxxClang
    llvmPackages.libllvm
    lm_sensors
    log4cxx
    logseq
    lolcat
    lrzsz
    lshw
    lsof
    lua
    lutris
    lynx
    lzip
    m4
    magic-wormhole
    mailspring
    mailutils
    maven
    mercurial
    mermaid-cli
    meson
    micro
    min
    mlocate
    mold
    moonlight-qt
    moreutils
    most
    mpc-cli
    mpv
    mu
    mudlet
    mupdf
    nacelle
    ncmpcpp
    ncurses
    ncurses
    neovide
    nethogs
    ninja
    nix-zsh-completions
    nixfmt-rfc-style
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.typescript-language-server
    nuclear
    nvme-cli
    nvtopPackages.full
    obfs4
    obs-cmd
    ollama
    openttd
    osdlyrics
    pandoc
    pastebinit
    patchelf
    pavucontrol
    peek
    pharo
    picard
    pipenv
    piper-tts
    pkg-config
    pnpm
    podman-tui
    poppler_utils
    powershell
    powerstat
    powertop
    pprof
    protobuf
    psmisc
    pyright
    qrcp
    qrencode
    qrscan
    qtcreator
    readability-cli
    retry
    rig
    ripgrep
    ripgrep-all
    roswell
    ruff
    sbcl
    sbclPackages.qlot
    sccache
    scrcpy
    scrot
    sdcv
    semgrep
    semgrep-core
    shellcheck
    shfmt
    shotcut
    silver-searcher
    simplescreenrecorder
    sioyek
    slack
    smartmontools
    sops
    spotdl
    spotify
    spotify-player
    sqlite
    sshfs
    stress-ng
    sunshine
    swaybg
    swaylock
    syncthing
    sysstat
    thunderbird
    tintin
    unstable.tmux
    xmlstarlet
    tokei
    tor
    tor-browser
    torsocks
    tree-sitter
    tree-sitter-grammars.tree-sitter-markdown
    typos
    unconvert
    unison
    unstable.gpsd
    unstable.babashka
    unstable.clash-meta
    unstable.ddgr
    unstable.devenv
    unstable.direnv
    unstable.geoipWithDatabase
    unstable.gopls
    unstable.isync
    unstable.jdt-language-server
    unstable.labwc-menu-generator
    unstable.labwc-tweaks-gtk
    unstable.nil
    unstable.niriswitcher
    unstable.nix-direnv
    unstable.nix-search-cli
    unstable.nixd
    unstable.obsidian
    unstable.qbittorrent
    unstable.quickemu
    unstable.quickshell
    unstable.rfc
    unstable.shell-gpt
    unstable.warp-terminal
    unstable.wezterm
    unstable.youtube-music
    unstable.zls
    unzip
    usbutils
    uv
    variety
    vimpager
    vlc
    w3m
    wakatime-cli
    watchexec
    waypipe
    wev
    wine64Packages.stagingFull
    winetricks
    wl-clipboard
    wlr-randr
    wmctrl
    wofi
    xfce.xfce4-panel
    xwayland-satellite
    yaml-language-server
    yazi
    yq
    yt-dlp
    ytmdl
    zerotierone
    tig
    zip
    zlib-ng
    zoxide
    zsh-nix-shell
    zulip
  ];
  # home.file.".Xmodmap" = { source = ./Xmodmap; };
  # home.file.".emacs.d/early-init.el" = { source = ./emacs-early-init.el; };
  # home.file.".emacs.d/init.el" = { source = ./emacs-init.el; };

  home.sessionVariables = {
    EMACS_TELEGA_SERVER_LIB_PREFIX = "${pkgs.unstable.tdlib}";
    CGO_ENABLED = "1";
    GO111MODULE = "auto";
  };

  home.sessionPath = [
    "/home/exec/.exec/bin"
    "/home/exec/.npm-global/bin"
    "/home/exec/.cargo/bin"
    "/home/exec/.zvm/bin"
    "/home/exec/go/bin"
  ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Sans Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  accounts = {
    email = {
      accounts = {
        execvy = {
          primary = true;
          realName = "Eval Exec";
          address = "execvy@gmail.com";
          userName = "execvy@gmail.com";
          flavor = "gmail.com";
          folders = {
            inbox = "Inbox";
            drafts = "Drafts";
            sent = "Sent";
            trash = "Trash";
          };
          gpg = {
            key = "4B453CE70F2646044171BACE0F0272C0D3AC91F7";
          };
          passwordCommand = "${pkgs.coreutils}/bin/cat /home/exec/pass/gapp.txt";
          imap = {
            host = "imap.gmail.com";
            port = 993;
            tls = {
              enable = true;
            };
          };
          imapnotify = {
            enable = true;
            boxes = [ "INBOX" ];
            extraArgs = [
              "-wait 1"
              "-log-level debug"
            ];
            extraConfig = {
              enableIDCommand = true;
            };
            onNotify = ''
              ${pkgs.unstable.isync}/bin/mbsync --verbose --new execvy:INBOX
            '';
            onNotifyPost = ''
              ${pkgs.libnotify}/bin/notify-send 'goimapnotify received new emails'
              /home/exec/.local/bin/emacsclient -e "
              (progn
                (unless (boundp 'mu4e--server-process)
                  (mu4e t))
                (mu4e-update-index-nonlazy)
                (message \"imapnotify received new mail.\"))"
            '';
          };

          msmtp = {
            enable = true;
          };
          # smtp = {
          #   host = "smtp.gmail.com";
          # };
          mu = {
            enable = false;
          };
        };
      };
    };
  };

  xdg.portal.enable = true;
  xdg.portal.configPackages = [
    pkgs.kdePackages.xdg-desktop-portal-kde
  ];
  xdg.portal.extraPortals = [
    pkgs.kdePackages.xdg-desktop-portal-kde
  ];

  # gtk.enable = true;
  # gtk.cursorTheme.package = pkgs.vanilla-dmz;
  # gtk.cursorTheme.name = "Vanilla-DMZ";
  # gtk.cursorTheme.size = 24;
  # gtk.theme.package = pkgs.fluent-gtk-theme;
  # gtk.theme.name = "Fluent";

  services = {
    mpd = {
      enable = true;
      # extraArgs = [ "" ];
      musicDirectory = "~/Music";
      extraConfig = ''
        auto_update "yes"
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
    sxhkd = {
      enable = true;
      extraConfig = "";
      keybindings = {
        "super + f" = "/home/exec/Scripts/apps/terminal.sh";
        "super + s" = "/home/exec/Scripts/apps/emacs.sh";
      };
    };
    imapnotify = {
      enable = true;
    };
    mbsync = {
      enable = false;
      # frequency = "*-*-* *:*:00,20,40";
      # postExec = ''
      #   /home/exec/Projects/git.savannah.gnu.org/git/emacs-build/emacs/bin/emacsclient -e "(progn (unless (boundp 'mu4e--server-process) (mu4e t)) (mu4e-update-index-nonlazy)(message \"mbsync executed.\"))"
      # '';
      verbose = true;
    };
  };
  xsession = {
    enable = false;
    # initExtra = ''
    #   ${pkgs.xorg.xmodmap}/bin/xmodmap -e "remove mod4 = Hyper_L";
    #   ${pkgs.xorg.xmodmap}/bin/xmodmap -e "add mod3 = Hyper_L";
    # '';
  };

  programs.firefox = {
    enable = true;
    package = pkgs.unstable.firefox;
    nativeMessagingHosts = [ pkgs.unstable.firefoxpwa ];
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/exec/Projects/github.com/eval-exec/nixos-configuration";
  };

  programs = {
    home-manager.enable = true;

    obs-studio = {
      enable = true;
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-websocket
      ];
    };
    vscode = {
      enable = true;
      package = pkgs.unstable.vscode.fhs;
    };
    msmtp = {
      enable = true;
    };
    chromium = {
      enable = true;
      package = pkgs.unstable.google-chrome;
      # commandLineArgs = [
      #   "--disable-crash-reporter"
      #   "--disable-crashpad-for-testing"
      #   "--disable-crashpad-forwarding"
      # ];
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
      # enableBashIntegration = true;
      icons = "auto";
      # extraOptions = [];
    };

    java = {
      enable = true;
      package = pkgs.jdk21;
    };
    # emacs = {
    #   enable = false;
    #   package = pkgs.emacs-git.override { withGTK3 = true; };
    #   # package = pkgs.emacs-git;
    #
    #   extraPackages = epkgs: [
    #     pkgs.emacsPackages.jinx
    #     pkgs.emacsPackages.mu4e
    #     pkgs.emacsPackages.rime
    #     pkgs.emacsPackages.vterm
    #     pkgs.emacsPackages.w3m
    #     (pkgs.emacsPackages.org.overrideAttrs (old: {
    #       patches = [ ];
    #     }))
    #     pkgs.librime
    #     pkgs.mu
    #     pkgs.tdlib
    #   ];
    # };

    fish = {
      enable = false;
      loginShellInit = ''
        set -U fish_greeting
      '';
      plugins = [
        {
          name = "wakatime-fish";
          src = pkgs.fishPlugins.wakatime-fish.src;
        }
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
      ];
    };

    zsh = {
      enable = true;
      # autosuggestion.enable = true;
      # syntaxHighlighting.enable = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      initExtraFirst = ''
        # zmodload zsh/zprof

        ZSH_DISABLE_COMPFIX=true

        autoload -Uz compinit
        for dump in ~/.zcompdump(N.mh+24); do
          compinit
        done
        compinit -C

        DISABLE_AUTO_UPDATE="true"
        DISABLE_MAGIC_FUNCTIONS="true"
        DISABLE_COMPFIX="true"

        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
        ZSH_AUTOSUGGEST_USE_ASYNC=1
      '';
      initExtra = '''';
      envExtra = ''
        setopt no_global_rcs
        skip_global_compinit=1
        export SPACESHIP_EXIT_CODE_SHOW=true;
        export LESS='-R -j7';
        export FZF_BASE="/home/exec/Projects/github.com/junegunn/fzf";
        # export FZF_BASE=${pkgs.fzf}/share/fzf;
        export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
        export NIXPKGS_ALLOW_UNFREE=1;
        # Preview file content using bat (https://github.com/sharkdp/bat)
        export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
        # CTRL-/ to toggle small preview window to see the full command
        # CTRL-Y to copy the command into clipboard using pbcopy
        export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard' --layout=reverse"
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
      initContent = ''
        if [[ "$ALACRITTY_SOCKET" != "" && "$TMUX" = "" ]]; then tmux a; fi

        # zprof
      '';

      shellAliases = {
        ding = "mpv ~/Music/notifications/ding-1-14705.mp3 &> /dev/null";
        cat = "bat -p";
        vim = "nvim";
        goland = "~/.local/share/JetBrains/Toolbox/apps/goland/bin/goland.sh";
        rustrover = "~/.local/share/JetBrains/Toolbox/apps/rustrover/bin/rustrover.sh";
        clion = "~/.local/share/JetBrains/Toolbox/apps/clion-nova/bin/clion.sh";
        idea = "~/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea.sh";
        # emacs = "${pkgs.emacs-git}/bin/emacsclient -nw";
        magit = ''
          \emacs -Q -nw -l ~/.emacs.d/init-nw.el --funcall magit
        '';
        gpt = "OPENAI_API_KEY=$(cat ~/.config/openai_api_key/key.private) sgpt";
        psgrep = "ps -eF | head -n1 && ps -eF | grep";
        cg = "cd $(git rev-parse --show-toplevel)";
      };
      history = {
        size = 10000000;
        save = 10000000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "man"
          # "warhol"  # Rarely used, disable for faster startup
          # "zsh-wakatime"  # Tracks every command, adds overhead
          "fzf-tab"
          "zsh-autosuggestions"
          "nix-shell"
          "colored-man-pages"
          "fast-syntax-highlighting"
        ];
        # theme = "mlh";
        custom = "/home/exec/.oh-my-zsh/custom";
      };
    };
    bash = {
      enable = true;
      enableCompletion = false;
      enableVteIntegration = true;
      historyFile = "/home/exec/.bash_history";

      shellAliases = {
        ding = "mpv ~/Music/notifications/ding-1-14705.mp3 &> /dev/null";
      };
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
      package = pkgs.unstable.fzf;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        command_timeout = 200;
        git_status = {
          disabled = true;
        };
        battery = {
          disabled = true;
        };
      };
    };
  };
  # systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  # systemd.users.services.mbsync.serviceConfig.SupplementaryGroups =
  #   [ config.users.groups.keys.name ];

  systemd.user = {

    timers = {
      # use_hyper_key = {
      #   Unit = { Description = "use_hyper_key"; };
      #   Install = { WantedBy = [ "timers.target" ]; };
      #   Timer = {
      #     OnBootSec = "3s";
      #     OnUnitActiveSec = "3s";
      #     Unit = "use_hyper_key.service";
      #   };
      # };
    };

    services = {
      # use_hyper_key = {
      #   Unit = { Description = "use_hyper_key"; };
      #   Install = { WantedBy = [ "default.rarget" ]; };
      #   Service = {
      #     Type = "oneshot";
      #     ExecStart = "true";

      #     # " ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'remove mod4 = Hyper_L' && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 37 = Hyper_L' && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'add mod3 = Hyper_L'";
      #   };
      # };
      clash = {
        Unit = {
          Description = "clash";
          X-SwitchMethod = "keep-old";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStart = "/home/exec/.config/clash/clash-premium -d /home/exec/.config/clash";
        };
      };

      matrix = {
        Unit = {
          Description = "matrix";
          X-SwitchMethod = "keep-old";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStartPre = "${pkgs.bash}/bin/bash -c 'until ${pkgs.iputils}/bin/ping -c1 bing.com; do ${pkgs.coreutils}/bin/sleep 1; done;'";
          ExecStart = "${pkgs.openssh}/bin/ssh -o ConnectTimeout=2 -n matrix_wan uptime && sleep infinity";
          RestartSec = 3;
          Restart = "always";
        };
      };

      matrix_port_forward = {
        Unit = {
          Description = "matrix port formward";
          X-SwitchMethod = "keep-old";
          Wants = [ "network-online.target" ];
          After = [
            "network-online.target"
            "matrix.service"
          ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          Restart = "always";
          RestartSec = 3;
          ExecStart = "${pkgs.openssh}/bin/ssh -S none -N -T -L 3000:127.0.0.1:3000 -L 9090:127.0.0.1:9090 -L 8899:127.0.0.1:8899 -L 48080:127.0.0.1:48080 -L 58080:127.0.0.1:8080 -L 11434:127.0.0.1:11434 -L 27631:127.0.0.1:27631 matrix_wan";
        };
      };

      watchman = {
        Unit = {
          Description = "Watchman for user %i";
          X-SwitchMethod = "keep-old";
          Wants = [ "network-online.target" ];
          After = [ "network-online.target" ];
        };
        Service = {
          Environment = "TMPDIR=/tmp/watchman_tmp";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /tmp/watchman_tmp";
          ExecStart = "${pkgs.watchman}/bin/watchman --foreground --log-level=2";
          ExecStop = "${pkgs.watchman}/bin/watchman shutdown-server";
          Restart = "always";
          RestartSec = 3;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      # distccd_forward = {
      #   Unit = {
      #     Description = "distccd formward";
      #     After = [ "network-online.target" ];
      #   };
      #   Install = {
      #     WantedBy = [ "default.target" ];
      #   };
      #   Service = {
      #     Restart = "always";
      #     RestartSec = 1;
      #     ExecStart = "${pkgs.openssh}/bin/ssh -N -T -L 3632:127.0.0.1:3632 matrix_wan";
      #   };
      # };

      # distccd_stats_forward = {
      #   Unit = {
      #     Description = "distccd stats formward";
      #     After = [ "network-online.target" ];
      #   };
      #   Install = {
      #     WantedBy = [ "default.target" ];
      #   };
      #   Service = {
      #     Restart = "always";
      #     RestartSec = 1;
      #     ExecStart = "${pkgs.openssh}/bin/ssh -N -T -L 3633:127.0.0.1:3633 matrix_wan";
      #   };
      # };

      # sccache_scheduler_forward = {
      #   Unit = {
      #     Description = "sccache scheduler formward";
      #     After = [ "network-online.target" ];
      #   };
      #   Install = {
      #     WantedBy = [ "default.target" ];
      #   };
      #   Service = {
      #     Restart = "always";
      #     RestartSec = 1;
      #     ExecStart = "${pkgs.openssh}/bin/ssh -N -T -L 10600:127.0.0.1:10600 matrix_wan";
      #   };
      # };

      # sccache_server_forward = {
      #   Unit = {
      #     Description = "sccache server formward";
      #     After = [ "network-online.target" ];
      #   };
      #   Install = {
      #     WantedBy = [ "default.target" ];
      #   };
      #   Service = {
      #     Restart = "always";
      #     RestartSec = 1;
      #     ExecStart = "${pkgs.openssh}/bin/ssh -N -T -L 10601:127.0.0.1:10601 matrix_wan";
      #   };
      # };

      terminal-daemon = {
        Unit = {
          After = [ "tmux.target" ];
          X-SwitchMethod = "keep-old";
          Description = "terminal daemon";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Restart = "always";
          RestartSec = 1;
          ExecStart = "${pkgs.kitty}/bin/kitty --title=main";
        };
      };

      tmux = {
        Unit = {
          Description = "tmux";
          X-SwitchMethod = "keep-old";
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "forking";
          ExecStart = "${pkgs.unstable.tmux}/bin/tmux new-session -d";
          ExecStop = "${pkgs.unstable.tmux}/bin/tmux kill-server";
          Restart = "always";
          RestartSec = 1;
        };
      };

      emacs = {
        Unit = {
          Description = "emacs";
          X-SwitchMethod = "keep-old";
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          Restart = "always";
          # RestartSec = 0;
          ExecStart = "${pkgs.nix}/bin/nix develop --impure /home/exec/Projects/github.com/emacs-mirror/emacs -c /home/exec/.local/bin/emacs";
          StandardOutput = "journal";
          StandardError = "journal";
        };
      };

      # slack = {
      #   Unit = {
      #     Description = "slack";
      #     After = [ "graphical-session.target" ];
      #   };
      #   Install = {
      #     WantedBy = [ "graphical-session.target" ];
      #   };
      #   Service = {
      #     Type = "simple";
      #     Restart = "always";
      #     RestartSec = 3;
      #     ExecStart = "${pkgs.slack}/bin/slack --silent";
      #   };
      # };

      # discord = {
      #   Unit = {
      #     Description = "discord";
      #     After = [ "graphical-session.target" ];
      #   };
      #   Install = {
      #     WantedBy = [ "graphical-session.target" ];
      #   };
      #   Service = {
      #     Type = "oneshot";
      #     RemainAfterExit = "yes";
      #     # Restart = "always";
      #     # RestartSec = 3;
      #     ExecStart = "${pkgs.discord}/bin/discord";
      #   };
      # };

      # thunderbird = {
      #   Unit = {
      #     Description = "thunderbird";
      #     After = [ "graphical-session.target" ];
      #   };
      #   Install = {
      #     WantedBy = [ "graphical-session.target" ];
      #   };
      #   Service = {
      #     Type = "simple";
      #     Restart = "always";
      #     RestartSec = 3;
      #     ExecStart = "${pkgs.thunderbird}/bin/thunderbird";
      #   };
      # };
    };
  };
}
