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
  home.stateVersion = "25.05";
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
    # inputs.ghostty.packages.x86_64-linux.default
    inputs.claude-desktop.packages.x86_64-linux.claude-desktop-with-fhs
    inputs.envycontrol.packages.x86_64-linux.default
    powerstat
    # inputs.quickshell.packages.x86_64-linux.default
    # ionshare
    # jetbrains.clion
    # jetbrains.goland
    # jetbrains.idea-ultimate
    # microsoft-edge-dev
    # nur.repos.linyinfeng.wemeet
    # nur.repos.xddxdd.baidunetdisk
    # nur.repos.xddxdd.netease-cloud-music
    # nur.repos.xddxdd.qqmusic
    # nur.repos.xddxdd.wechat-uos
    # spotdl
    # tigervnc
    unstable.quickemu
    unstable.davinci-resolve
    # unstable.vagrant
    # vivaldi
    # vivaldi-ffmpeg-codecs
    age
    aileron
    uv
    alacritty
    alejandra
    psmisc
    alsa-utils
    thunderbird

    amdgpu_top
    android-tools
    ascii
    asciidoc
    ast-grep
    guile
    atool
    unstable.zed-editor
    unstable.jdt-language-server
    autoconf
    nvme-cli
    smartmontools
    automake
    awscli2
    bat
    bc
    bear
    bitcoin
    bottles
    brave
    browsh
    gnuplot
    btop
    bun
    calibre
    ccls
    lolcat
    chafa
    iotop
    chromaprint
    clinfo
    clj-kondo
    cljfmt
    clojure
    clojure-lsp
    cloudflared
    cmake
    cool-retro-term
    copyq
    maven
    coreutils-full
    cppcheck
    cpulimit
    cpupower-gui
    crate2nix
    ddcui
    ddcutil
    delta
    deno
    difftastic
    dig
    direnv
    discord
    distcc
    dmidecode
    kdePackages.dolphin
    dpkg
    droidcam
    du-dust
    element-desktop
    epubcheck
    errcheck
    evtest
    exercism
    extra-cmake-modules
    fastfetch
    fd
    at
    ffmpeg-full
    fftw
    fish
    flameshot
    fpp
    fuse
    fuse3
    gdb
    gf
    gh
    gh-dash
    ghostie
    gifski
    gimp
    gitstatus
    glxinfo
    gnutls
    go-ethereum
    go2tv
    goimapnotify
    golangci-lint
    google-cloud-sdk
    gptcommit
    graphviz
    grc
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtest
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
    inputs.amber.packages.${pkgs.system}.default
    intel-gpu-tools
    ipfs
    jemalloc
    joker
    jq
    just
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
    llvmPackages.libcxx
    llvmPackages.libllvm
    llvmPackages.libcxxClang
    lm_sensors
    logseq
    lrzsz
    lshw
    lsof
    lua
    lutris
    lynx
    m4
    magic-wormhole
    mailutils
    mercurial
    mermaid-cli
    meson
    micro
    mlocate
    mold
    moonlight-qt
    moreutils
    most
    mpc-cli
    mpv
    mu
    mudlet
    nacelle
    ncmpcpp
    ncurses
    ncurses
    neovide
    nil
    nil
    ninja
    nix-zsh-completions
    nixd
    nixfmt-rfc-style
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.typescript-language-server
    nuclear
    nvtopPackages.full
    # unstable.nyxt
    obfs4
    ollama
    osdlyrics
    pandoc
    pastebinit
    patchelf
    peek
    pharo
    picard
    pipenv
    piper-tts
    pkg-config
    poppler_utils
    powershell
    powertop
    pprof
    protobuf
    pyright
    qrcp
    qrscan
    qrencode
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
    silver-searcher
    simplescreenrecorder
    sioyek
    slack
    sops
    spotdl
    spotify
    spotify-player
    sqlite
    sshfs
    sunshine
    syncthing
    sysstat
    tintin
    tmux
    tokei
    tor
    tor-browser
    torsocks
    tree-sitter
    tree-sitter-grammars.tree-sitter-markdown
    typos
    unconvert
    unison
    unstable.babashka
    # unstable.ghostty
    unstable.ddgr
    unstable.gopls
    unstable.nix-search-cli
    unstable.obsidian
    unstable.qbittorrent
    unstable.shell-gpt
    unstable.warp-terminal
    unstable.wezterm
    unstable.youtube-music
    unzip
    variety
    vimpager
    vlc
    w3m
    wakatime
    waypipe
    wev
    unstable.whisper-ctranslate2
    wine64Packages.stagingFull
    winetricks
    wl-clipboard
    wmctrl
    wofi
    yaml-language-server
    yq
    yt-dlp
    ytmdl
    zerotierone
    zip
    unstable.zig
    zlib
    unstable.zls
    zoxide
    zsh
    zsh-autosuggestions
    zsh-fzf-tab
    zsh-nix-shell
    zsh-powerlevel10k
    zulip
  ];
  # home.file.".Xmodmap" = { source = ./Xmodmap; };
  # home.file.".emacs.d/early-init.el" = { source = ./emacs-early-init.el; };
  # home.file.".emacs.d/init.el" = { source = ./emacs-init.el; };

  home.sessionVariables = {
    EMACS_TELEGA_SERVER_LIB_PREFIX = "${pkgs.unstable.tdlib}";
    CGO_ENABLED="1";
    GO111MODULE="auto";
  };

  home.sessionPath = [
    "/home/exec/.exec/bin"
    "/home/exec/.npm-global/bin"
    "/home/exec/.cargo/bin"
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
          passwordCommand = "cat /home/exec/pass/gapp.txt";
          imap = {
            host = "imap.gmail.com";
            port = 993;
            tls = {
              enable = true;
            };
          };
          imapnotify = {
            enable = false;
            boxes = [ "INBOX" ];
            # extraConfig = {
            # wait = 0;
            # };
            onNotify = ''
              systemctl --user start mbsync
            '';
            onNotifyPost = ''
              /home/exec/Projects/git.savannah.gnu.org/git/emacs-build/emacs/bin/emacsclient -e "(progn (unless (boundp 'mu4e--server-process) (mu4e t)) (mu4e-update-index-nonlazy)(message \"imapnotify received new mail.\"))"
            '';
          };

          mbsync = {
            enable = false;
            create = "both";
            expunge = "both";
            extraConfig = {
              account = {

              };
              channel = {
                MaxMessages = 20000;
              };
              # local = { };
              # remote = { };
            };
            # groups = {
            #   execvy = {
            #     channels = {
            #       inbox = {
            #         farPattern = "INBOX";
            #         nearPattern = "inbox";
            #         extraConfig = {
            #           Create = "Both";
            #           MaxMessages = 20000;
            #         };
            #       };
            #       sent = {
            #         farPattern = "[Gmail]/Sent Mail";
            #         nearPattern = "sent";
            #         extraConfig = {
            #           Create = "Both";
            #         };
            #       };
            #       trash = {
            #         farPattern = "[Gmail]/Trash";
            #         nearPattern = "trash";
            #         extraConfig = {
            #           Create = "Both";
            #         };
            #       };
            #       spam = {
            #         farPattern = "[Gmail]/Spam";
            #         nearPattern = "spam";
            #         extraConfig = {
            #           Create = "Both";
            #         };
            #       };
            #     };
            #   };
            # };
            patterns = [ "*" ];
            remove = "both";
            subFolders = "Verbatim";
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

  services = {
    mpd = {
      enable = false;
      # extraArgs = [ "" ];
      musicDirectory = "~/Music";
      extraConfig = ''
        # auto_update "yes"
        # audio_output {
        #   type "pipewire"
        #   name "My PipeWire Output"
        # }
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
  programs.nh = {
	  enable = true;
	  clean.enable = true;
	  clean.extraArgs = "--keep-since 4d --keep 3";
	  flake = "/home/exec/Projects/github.com/nixos-configuration";
  };


  programs = {
    home-manager.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ obs-backgroundremoval ];
    };
    vscode = {
      enable = true;
      package = pkgs.unstable.vscode.fhs;
    };

    mbsync = {
      enable = false;
      package = pkgs.unstable.isync;
      extraConfig = "";
    };
    msmtp = {
      enable = true;
    };
    chromium = {
      enable = true;
    };
    google-chrome = {
      enable = true;
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
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      envExtra = ''
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
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh;
        if [[ "$ALACRITTY_SOCKET" != "" && "$TMUX" = "" ]]; then tmux a; fi
      '';

      shellAliases = {
        ding = "mpv ~/Music/notifications/ding-1-14705.mp3 &> /dev/null";
        cat = "bat -p";
        vim = "nvim";
        goland = "~/.local/share/JetBrains/Toolbox/apps/goland/bin/goland.sh";
        rustrover = "~/.local/share/JetBrains/Toolbox/apps/rustrover/bin/rustrover.sh";
        clion = "~/.local/share/JetBrains/Toolbox/apps/clion-nova/bin/clion.sh";
        idea = "~/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea.sh";
        update = "sudo nixos-rebuild switch";
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
          "fzf"
          "man"
          "warhol"
          "zsh-wakatime"
          "fzf-tab"
          "nix-shell"
          "colored-man-pages"
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
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStartPre = "${pkgs.bash}/bin/bash -c 'until ${pkgs.iputils}/bin/ping -c1 bing.com; do ${pkgs.coreutils}/bin/sleep 1; done;'";
          ExecStart = "${pkgs.openssh}/bin/ssh -o ConnectTimeout=2 -n matrix_wan_exec uptime && sleep infinity";
          RestartSec = 3;
          Restart = "always";
        };
      };

      matrix_port_forward = {
        Unit = {
          Description = "matrix port formward";
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
          ExecStart = "${pkgs.openssh}/bin/ssh -S none -N -T -L 48080:127.0.0.1:48080 -L 58080:127.0.0.1:8080 -L 11434:127.0.0.1:11434 -L 27631:127.0.0.1:27631 matrix_wan";
        };
      };

      watchman = {
        Unit = {
          Description = "Watchman for user %i";
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
          Description = "terminal daemon";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Restart = "always";
          RestartSec = 0;
          ExecStart = "${pkgs.kitty}/bin/kitty";
        };
      };

      tmux = {
        Unit = {
          Description = "tmux";
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "forking";
          ExecStart = "${pkgs.tmux}/bin/tmux new-session -d";
          ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
        };
      };

      emacs = {
        Unit = {
          Description = "emacs";
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          Restart = "always";
          # RestartSec = 0;
          ExecStart = "${pkgs.nix}/bin/nix-shell /home/exec/.config/emacs/default.nix --run /home/exec/.local/bin/emacs";
          # ExecStart = "/home/exec/.local/bin/emacs";
          # StandardInput = "tty";
          StandardOutput = "file:/tmp/debug.log";
          StandardError = "file:/tmp/error.log";
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
