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
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-27.3.11" ];

    };
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.username = "exec";
  home.homeDirectory = "/home/exec";
  home.stateVersion = "24.05";
  # home.pointerCursor = {
  #   package = pkgs.gnome.gnome-themes-extra;
  #   name = "Breeze";
  #   size = 24;
  #   gtk.enable = true;
  # };

  home.packages = with pkgs; [
    # nur.repos.xddxdd.wechat-uos
    # nur.repos.xddxdd.baidunetdisk
    # nur.repos.xddxdd.netease-cloud-music
    # nur.repos.xddxdd.qqmusic
    # nur.repos.linyinfeng.wemeet
    inputs.amber.packages.${pkgs.system}.default
    age
    alsa-utils
    ytmdl
    bun
    obfs4
    lf
    mailutils
    btop
    piper-tts
    tokei
    cpulimit
    watchman
    nixd
    gnutls
    unison
    inotify-info
    inotify-tools
    ccls
    sshfs
    discord
    syncthing
    unstable.zed-editor
    slack
    ripgrep
    dpkg
    yaml-language-server
    ascii
    ruff
    sqlite
    ollama
    nyxt
    awscli2
    waypipe
    lua
    gimp
    readability-cli
    magic-wormhole
    brave
    android-tools
    wl-clipboard
    sunshine
    moonlight-qt
    # tigervnc
    nil
    aileron
    alacritty
    cloudflared
    pstree
    zerotierone
    alejandra
    fastfetch
    kodi
    zoxide
    pprof
    jemalloc
    amdgpu_top
    python311Packages.argostranslate
    shfmt
    zls
    go2tv
    gopls
    lutris
    atool
    autoconf
    poppler_utils
    automake
    babashka
    gtest
    gmock
    bat
    bear
    # graalvm-ce
    # beets
    bitcoin
    ripgrep-all
    browsh
    calibre
    chromaprint
    clinfo
    m4
    clj-kondo
    cljfmt
    clojure
    clojure-lsp
    cmake
    extra-cmake-modules
    cool-retro-term
    copyq
    coreutils-full
    cpupower-gui
    powertop
    crate2nix
    ddcui
    ddcutil
    delta
    deno
    difftastic
    dig
    direnv
    dmidecode
    dolphin
    bc
    du-dust
    element-desktop
    epubcheck
    evtest
    exercism
    fd
    lazygit
    ffmpeg-full
    fftw
    flameshot
    fuse
    fuse3
    gdb
    gf
    gh
    ghostie
    gifski
    # github-copilot-cli
    # github-desktop
    glxinfo
    go-ethereum
    goimapnotify
    # vivaldi
    # vivaldi-ffmpeg-codecs
    google-cloud-sdk
    gptcommit
    graphviz
    grc
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    helix
    httpie
    cask
    hugo
    iftop
    imagemagick
    inetutils
    intel-gpu-tools
    isync
    # jetbrains.clion
    # jetbrains.goland
    # jetbrains.idea-ultimate
    joker
    jq
    keyd
    kitty
    kitty-themes
    leiningen
    libcamera
    libfaketime
    libnotify
    libressl
    libsForQt5.khotkeys
    libstdcxx5
    llvmPackages.libcxx
    fontforge
    fontforge-fonttools
    fontforge-gtk
    llvmPackages.libcxxClang
    lm_sensors
    logseq
    lshw
    micro
    lsof
    scrot
    mudlet
    tintin
    lynx
    mercurial
    mermaid-cli
    meson
    # microsoft-edge-dev
    mlocate
    mold
    moreutils
    most
    mpc-cli
    mpv
    mu
    nacelle
    ncmpcpp
    ncurses
    ncurses
    neovide
    chafa
    nil
    ninja
    nixfmt-rfc-style
    pyright
    nodePackages.prettier
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    nuclear
    # ionshare
    osdlyrics
    pandoc
    pastebinit
    distcc
    patchelf
    fpp
    peek
    pharo
    picard
    pipenv
    pkg-config
    powershell
    protobuf
    qbittorrent
    qrcp
    retry
    roswell
    sbcl
    sbclPackages.qlot
    sccache
    sdcv
    semgrep
    semgrep
    semgrep-core
    shell-gpt
    silver-searcher
    rig
    simplescreenrecorder
    sioyek
    sops
    spotdl
    # spotdl
    spotify
    sysstat
    tmux
    tor
    torsocks
    tor-browser
    tree-sitter
    tree-sitter-grammars.tree-sitter-markdown
    typos
    zip
    gh-dash
    unzip
    vagrant
    variety
    inotify-tools
    inotify-info
    vimpager
    vlc
    w3m
    wakatime
    wev
    wezterm
    winetricks
    wine64Packages.stagingFull
    bottles
    wmctrl
    wofi
    yesplaymusic
    unstable.youtube-music
    yq
    yt-dlp
    zig
    zlib
    zsh
    fish
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-fzf-tab
    zsh-nix-shell
    nix-zsh-completions
    zulip
    scrcpy
  ];
  # home.file.".Xmodmap" = { source = ./Xmodmap; };
  # home.file.".emacs.d/early-init.el" = { source = ./emacs-early-init.el; };
  # home.file.".emacs.d/init.el" = { source = ./emacs-init.el; };

  home.sessionVariables = {
    EMACS_TELEGA_SERVER_LIB_PREFIX = "${pkgs.unstable.tdlib}";
  };

  home.sessionPath = [
    "/home/exec/.npm-global/bin"
    "/home/exec/.cargo/bin"
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
          realName = "Eval EXEC";
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
            enable = true;
            boxes = [ "INBOX" ];
            extraConfig = {
              wait = 0;
            };
            onNotify = ''
              systemctl --user start mbsync
            '';
            onNotifyPost = ''
              /home/exec/Projects/git.savannah.gnu.org/git/emacs-build/emacs/bin/emacsclient -e "(progn (unless (boundp 'mu4e--server-process) (mu4e t)) (mu4e-update-index-nonlazy)(message \"imapnotify received new mail.\"))"
            '';
          };

          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
            extraConfig = {
              account = {

              };
              channel = {
                MaxMessages = 20000;
              };
              local = { };
              remote = { };
            };
            groups = {
              execvy = {
                channels = {
                  inbox = {
                    farPattern = "INBOX";
                    nearPattern = "inbox";
                    extraConfig = {
                      Create = "Both";
                      MaxMessages = 20000;
                    };
                  };
                  sent = {
                    farPattern = "[Gmail]/Sent Mail";
                    nearPattern = "sent";
                    extraConfig = {
                      Create = "Both";
                    };
                  };
                  trash = {
                    farPattern = "[Gmail]/Trash";
                    nearPattern = "trash";
                    extraConfig = {
                      Create = "Both";
                    };
                  };
                  spam = {
                    farPattern = "[Gmail]/Spam";
                    nearPattern = "spam";
                    extraConfig = {
                      Create = "Both";
                    };
                  };
                };
              };
            };
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
            enable = true;
          };
        };
      };
    };
  };

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
      enable = true;
      # frequency = "*-*-* *:*:00,20,40";
      postExec = ''
        /home/exec/Projects/git.savannah.gnu.org/git/emacs-build/emacs/bin/emacsclient -e "(progn (unless (boundp 'mu4e--server-process) (mu4e t)) (mu4e-update-index-nonlazy)(message \"mbsync executed.\"))"
      '';
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

  programs = {
    home-manager.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ obs-backgroundremoval ];
    };
    vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (
        ps: with ps; [
          rustup
          zlib
          openssl.dev
          pkg-config
        ]
      );
    };

    mbsync = {
      enable = true;
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
    thunderbird = {
      enable = true;
      profiles = {
        exec = {
          isDefault = true;
        };
      };
    };
    go = {
      enable = true;
    };
    eza = {
      enable = true;
      # enableBashIntegration = true;
      icons = true;
      # extraOptions = [];
    };

    java = {
      enable = true;
      package = pkgs.jdk21;
    };
    emacs = {
      enable = false;
      package = pkgs.emacs-git.override { withGTK3 = true; };
      # package = pkgs.emacs-git;

      extraPackages = epkgs: [
        pkgs.emacsPackages.jinx
        pkgs.emacsPackages.mu4e
        pkgs.emacsPackages.rime
        pkgs.emacsPackages.vterm
        pkgs.emacsPackages.w3m
        (pkgs.emacsPackages.org.overrideAttrs (old: {
          patches = [ ];
        }))
        pkgs.librime
        pkgs.mu
        pkgs.tdlib
      ];
    };

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
      initExtra = ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh;
        if [[ "$ALACRITTY_SOCKET" != "" && "$TMUX" = "" ]]; then tmux a; fi
      '';

      shellAliases = {
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
        gpt = "sgpt";
        psgrep = "ps -eF | head -n1 && ps -eF | grep";
        cg = "cd $(git rev-parse --show-toplevel)";
      };
      history = {
        size = 10000000;
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

      matrix_port_forward = {
        Unit = {
          Description = "ollama port formward";
          Wants = [ "network-online.target" ];
          After = [ "network-online.target" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          Restart = "always";
          RestartSec = 3;
          ExecStart = "${pkgs.openssh}/bin/ssh -N -T -L 11434:127.0.0.1:11434 -L 27631:127.0.0.1:27631 matrix_wan";
        };
      };

      watchman = {
        Unit = {
          Description = "Watchman for user %i";
          Wants = [ "network-online.target" ];
          After = [ "network-online.target" ];
        };
        Service = {
          ExecStart = "${pkgs.watchman}/bin/watchman --foreground --log-level=1";
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

      alacritty-daemon = {
        Unit = {
          Description = "alacritty daemon";
          After = [ "tmux.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Restart = "always";
          RestartSec = 0;
          ExecStart = "${pkgs.alacritty}/bin/alacritty";
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
    };
  };

}
