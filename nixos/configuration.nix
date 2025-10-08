# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

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
      cudaSupport = false;
      permittedInsecurePackages = [
        "electron-11.5.0"
        "electron-24.8.6"
        "electron-25.9.0"
        "electron-19.1.9"
        "electron-28.3.3"
        "electron-27.3.11"
      ];
      vivaldi = {
        proprietaryCodecs = true;
        enableWideVine = true;
      };
      nvidia.acceptLicense = true;

    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      gc = {
        automatic = true;
        dates = "weekly";
      };

      distributedBuilds = true;
      settings = {

        # let remote build machines fetch substitutes from their own caches
        builders-use-substitutes = true;

        auto-optimise-store = true;
        trusted-users = [
          "root"
          "exec"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        ];

        substituters = [
          "https://mirrors.ustc.edu.cn/nix-channels/store"
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          # "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://devenv.cachix.org"
          "https://chaotic-nyx.cachix.org"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    # Bootloader.
    # https://www.reddit.com/r/Lofree/comments/16vg1qa/lofree_flow_good_with_some_issues/
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
      options hid_apple fnmode=2 swap_opt_cmd=1
    '';

    tmp = {
      useTmpfs = true;
      tmpfsSize = "24G";
      cleanOnBoot = true;
    };
  };
  console = {
    useXkbConfig = true;
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };

  documentation = {
    enable = true;
    dev.enable = true;
    man.generateCaches = false;
  };

  networking = {
    hostName = "Mufasa"; # Define your hostname.
    extraHosts = ''
      127.0.0.1 localhost
    '';
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = false;
      wifi.backend = "wpa_supplicant";
      logLevel = "INFO";
      dispatcherScripts = [
        {
          source = ./scripts/network-dispatcher.sh;
          type = "basic";
        }

      ];
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "2606:4700:4700::1111"
    ];
    firewall = {
      enable = false;
      # allowedTCPPortRanges = [{
      #   from = 0;
      #   to = 65535;
      # }];
      # allowedUDPPortRanges = [{
      #   from = 0;
      #   to = 65535;
      # }];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-rime
          fcitx5-chinese-addons
          fcitx5-with-addons
          fcitx5-configtool
          fcitx5-gtk
          fcitx5-pinyin-zhwiki
          kdePackages.fcitx5-qt
        ];
      };
    };
  };
  specialisation = {
    tty = {
      configuration = {
        services.displayManager.sddm.enable = lib.mkForce false;
        services.desktopManager = {
          plasma6.enable = lib.mkForce false;
        };
        services.flatpak.enable = lib.mkForce false;

        services.xserver = {
          enable = lib.mkForce false;
        };
      };
    };
  };

  # services.system76-scheduler.enable = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [ "--autopilot" ];
  };

  services.journald.extraConfig = ''
    Storage=volatile
  '';

  services = {
    power-profiles-daemon.enable = false;

    auto-cpufreq.enable = false;
    auto-cpufreq.settings = {
      battery = {
        governor = "powersave"; # Or "conservative", "ondemand", etc.
        energy_performance_preference = "power";
        turbo = "never"; # Or "auto", "always"
        energy_perf_bias = "power";
      };
      charger = {
        governor = "performance"; # Or "powersave", "conservative", etc.
        energy_performance_preference = "performance";
        turbo = "auto"; # Or "always", "never"
        energy_perf_bias = "performance";
      };

    };

    atd.enable = true;
    blueman.enable = false;
    dictd = {
      enable = true;
      DBs = with pkgs.dictdDBs; [
        wiktionary
        wordnet
      ];

    };
    kmscon = {
      enable = false;
      useXkbConfig = true;
    };

    fwupd.enable = false;
    desktopManager = {
      plasma6.enable = true;
    };

    samba = {
      enable = true;
      settings = {
        public = {
          path = "/home/exec/Temp/samba";
          browseable = true;
          writable = true;
          printable = false;
          createMask = "0777";
        };
      };
    };
    flatpak = {
      enable = true;
    };
    guix = {
      enable = true;
    };
    fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };
    keyd = {
      enable = false;
      keyboards.default.settings = {
        main = {
          capslock = "layer(control)";
          leftcontrol = "layer(hyper)";
        };
        "hyper:C-M-A" = { };
      };
    };
    # input-remapper = {
    #   enable = false;
    #   enableUdevRules = false;
    # };
    touchegg = {
      enable = false;
    };

    acpid = {
      enable = true;
      logEvents = true;
      # Define AC adapter event handlers
      acEventCommands = ''
        echo AC adapter event: $1
        vals=($1)  # space separated string to array of multiple values
        case ''${vals[3]} in
          00000001)
            echo plugged in
            ${pkgs.linuxPackages.cpupower}/bin/cpupower frequency-set -g performance
            ${pkgs.linuxPackages.cpupower}/bin/cpupower set -b 0 --epp performance
            ;;
          00000000)
            # AC unplugged - add your commands here
            echo unplugged
            ${pkgs.linuxPackages.cpupower}/bin/cpupower frequency-set -g powersave
            ${pkgs.linuxPackages.cpupower}/bin/cpupower set -b 15 --epp power
            echo disable turbo...
            echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
            echo disable turbo done
            ;;
          *)
            echo unknown acpi event
            ;;
        esac
      '';
    };

    logind.extraConfig = ''
      RuntimeDirectorySize=16G
    '';

    thermald.enable = false;
    thermald.debug = false;

    # Enable the X11 windowing system.

    # services.nix-serve = {
    #   enable = true;
    #   # secretKeyFile = "/var/cache-priv-key.pem";
    # };

    # udev = { extraRules = "\n"; };

    resolved = {
      enable = false;
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
    displayManager = {
      defaultSession = "plasma";
      enable = true;
      ly = {
        enable = false;
      };

      sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = true;
        wayland.compositor = "kwin";
      };
      autoLogin = {
        enable = false;
        user = "exec";
      };
    };

    libinput.enable = true;
    libinput.touchpad.accelProfile = "flat";
    libinput.touchpad.accelSpeed = "0.5";
    # libinput.touchpad.naturalScrolling = true;
    # libinput.touchpad.scrollMethod = "twofinger";
    # libinput.touchpad.tappingButtonMap = "lrm";
    # libinput.touchpad.disableWhileTyping = true;
    # libinput.touchpad.accelSpeed = "0.6"; # null

    # Configure keymap in X11
    xserver = {
      enable = true;
      xkb = {
        options = "ctrl:hyper_capscontrol";
      };

      videoDrivers = [
        "modesetting"
        "nvidia"
      ];

      #   config = lib.mkAfter ''
      #     Section "Module"
      #         Load           "modesetting"
      #     EndSection

      #     Section "Device"
      #         Identifier     "amdgpu"
      #         Driver         "amdgpu"
      #         BusID          "PCI:9@0:0:0"
      #         Option         "AllowEmptyInitialConfiguration"
      #         Option         "AllowExternalGpus" "True"
      #     EndSection

      #     Section "Screen"
      #         Identifier "Screen-amdgpu[0]"
      #     	  Device "amdgpu"
      #     EndSection

      #     Section "Device"
      #     	  Identifier "Screen0"
      #     	  Driver "modesetting"
      #     	  BusId "PCI:0:2:0"
      #     EndSection

      #     Section "Screen"
      #         Identifier "eDP-1-1"
      #         Monitor "eDP-1-1"
      #         Device "Screen0"
      #     EndSection
      #   '';

      # Enable touchpad support (enabled default in most desktopManager).

      # Enable the KDE Plasma Desktop Environment.
      displayManager = {
        # lightdm.enable = true;
        # xserverArgs = [ "-verbose" "-logverbose" ];
        # setupCommands = "";
        # sessionCommands run before setupCommands
        # sessionCommands =
        #   "${pkgs.xorg.setxkbmap}/bin/setxkbmap -verbose 10 -layout us-mine";
      };
    };
    ollama = {
      enable = false;
      package = pkgs.unstable.ollama;
      # sandbox = false;
      host = "127.0.0.1";
      port = 11435;
      # writablePaths = [ "/home/exec/.ollama" ];
      models = "/home/exec/.ollama/models";
      acceleration = "cuda";
    };

    wyoming = {

      # faster-whisper = {
      #
      #   servers = {
      #     "default" = {
      #       enable = true;
      #       device = "cuda";
      #       model = "small.en";
      #       uri = "tcp://0.0.0.0:10300";
      #       language = "en";
      #     };
      #   };
      # };
      piper = {
        servers = {
          "default" = {
            enable = true;
            # see https://github.com/rhasspy/rhasspy3/blob/master/programs/tts/piper/script/download.py
            # or en_US-arctic-medium speaker=14
            voice = "en-us-ryan-medium";
            # voice = "en-us-arctic-medium";
            # voice = "en-us-bryce-medium";
            uri = "tcp://0.0.0.0:10200";
            speaker = 0;
          };
        };
      };
    };

    # Enable CUPS to print documents.
    printing.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = false;
      wireplumber.extraConfig."10-disable-camera" = {
        "wireplumber.profiles" = {
          main = {
            "monitor.libcamera" = "disabled";
          };
        };

      };
      # extraLv2Packages = with pkgs; [
      #   lsp-plugins
      #   rnnoise-plugin
      # ];
      # extraConfig.pipewire = {
      #   "20-noise-cancel" = {
      #     "context.modules" = [
      #       {
      #         # https://github.com/werman/noise-suppression-for-voice
      #         "name" = "libpipewire-module-filter-chain";
      #         "flags" = [
      #           "ifexists"
      #           "nofail"
      #         ];
      #         "args" = {
      #           "node.description" = "Noise Canceling Source";
      #           "media.name" = "Noise Canceling Source";
      #           "filter.graph" = {
      #             "nodes" = [
      #               {
      #                 "type" = "ladspa";
      #                 "name" = "rnnoise";
      #                 "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
      #                 "label" = "noise_suppressor_mono";
      #                 "control" = {
      #                   "VAD Threshold (%)" = 35.0;
      #                   "VAD Grace Period (ms)" = 500;
      #                   "Retroactive VAD Grace (ms)" = 30;
      #                 };
      #               }
      #             ];
      #           };
      #           "capture.props" = {
      #             # "node.name" = "capture.rnnoise_source";
      #             "node.passive" = true;
      #             "audio.rate" = 48000;
      #             "node.name" = "noise_cancel.cancel";
      #             "node.description" = "Noise Cancel Capture";
      #             "target.object" = "echo_cancel.echoless";
      #           };
      #           "playback.props" = {
      #             "node.name" = "noise_cancel.playback";
      #             "node.description" = "Noise Cancel Playback";
      #             "media.class" = "Audio/Source";
      #             "audio.rate" = 48000;
      #             "node.autoconnect" = false;
      #           };
      #         };
      #       }
      #     ];
      #   };
      # };
    };
  };

  security = {
    wrappers = {
      criu = {
        owner = "exec";
        group = "users";
        capabilities = "cap_checkpoint_restore+eip";
        source = "${pkgs.criu}/bin/criu";
      };
    };
    rtkit.enable = true;
    pam.services.sddm.enableKwallet = true;
    pam.services.kdewallet = {
      name = "kdewallet";
      enableKwallet = true;
    };
    # sudo = {
    #   extraRules = [
    #     {
    #       commands = [
    #         {
    #           command = "/run/current-system/sw/bin/renice";
    #           options = [ "NOPASSWD" ];
    #         }
    #       ];
    #       groups = [ "wheel" ];
    #     }
    #   ];
    # };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.exec = {
    isNormalUser = true;
    description = "exec";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "kvm"
      "vboxusers"
      "video"
      "render"
    ];
    packages = with pkgs; [
      firefox
      # kate
    ];
  };
  users.defaultUserShell = pkgs.zsh;
  virtualisation = {
    libvirtd.enable = true;
    # xen.enable = false;
    waydroid.enable = true;

    virtualbox = {
      host = {
        enable = true;
        # package = pkgs.linuxKernel.packages.linux_6_16.virtualbox;
        # enableHardening = false;
        # enableExtensionPack = true;
      };
      guest.enable = false;
    };
    docker = {
      enable = true;

      daemon.settings = {
        bridge = "none";
      };
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = false;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    vmware = {
      host = {
        enable = true;
      };
    };
  };

  users.extraUsers.exec.extraGroups = [ "libvirtd" ];

  users.extraGroups.vboxusers.members = [ "exec" ];
  # home-manager = {
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  #   users.exec = import ./home.nix;
  # };

  # Allow unfree packages
  fonts = {
    fontDir = {
      enable = true;
      decompressFonts = true;
    };
    enableDefaultPackages = true;
    packages = with pkgs; [
      symbola
      iosevka
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      sarasa-gothic
      source-han-sans
      source-han-serif
      liberation_ttf
      ubuntu_font_family
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      wqy_zenhei
      wqy_microhei
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif"
          "Noto Color Emoji"
          "Twitter Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Sans Egyptian Hieroglyphs"
        ];
      };
    };
  };

  environment = {
    wordlist.enable = true;
    # sessionVariables = {
    #   LIBVA_DRIVER_NAME = "iHD";
    # };
    variables = {
      # XKB_DEFAULT_LAYOUT = "us";
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland";
      OLLAMA_HOST = "http://127.0.0.1:11434";
      EDITOR = "nvim";
      VISUAL = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
    localBinInPath = true;
    pathsToLink = [ ];
  };

  environment.systemPackages = with pkgs; [
    linuxHeaders
    # libsForQt5.xdg-desktop-portal-kde
    # libinput
    kdePackages.xdg-desktop-portal-kde
    linuxKernel.packages.linux_6_16.perf
    kdePackages.kde-gtk-config
    kdePackages.qtvirtualkeyboard
    kdePackages.plasma-sdk
    kdePackages.discover
    xdg-desktop-portal
    xdg-utils
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    appimage-run
    cachix
    gpu-screen-recorder # CLI
    gpu-screen-recorder-gtk # GUI
    clang
    clang_multi
    wlrctl
    glibc
    glibc_multi
    gcc
    libgcc
    (aspellWithDicts (
      ds: with ds; [
        en
        en-computers
        en-science
      ]
    ))
    docker-compose
    nvidia-container-toolkit
    nvidia-container-toolkit.tools
    libnvidia-container
    # inputs.kwin-effects-forceblur.packages.${pkgs.system}.default

    qt6.full
    qt6.qtwebsockets
    kdePackages.qtwebsockets
    wayland-utils
    vulkan-tools
    easyeffects
    kdePackages.qtmultimedia
    gst_all_1.gst-libav
    # (python3.withPackages (python-pkgs: [ python-pkgs.websockets ]))
    dua
    duf
    file
    git
    git-lfs
    glibcInfo
    gnumake
    interception-tools
    libclang
    libcxx
    libvterm
    lldb
    man-pages-posix
    man-pages-posix
    wireplumber
    ncurses
    ncurses5
    neovim
    nodejs
    openssl
    pciutils
    pinentry-curses
    pinentry-emacs
    pinentry-qt
    pkg-config
    polkit
    proxychains-ng
    python3
    qemu
    scheme-manpages
    stdmanpages
    steam-run
    sysfsutils
    tdesktop
    tdrop
    tree
    vim
    wakatime
    wget
    xclip
    xdotool
    xfsprogs
    xorg.libxcb
    xorg.xhost
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilwm
    xorg.xdpyinfo
    xorg.xev
    xorg.xkbcomp
    xorg.xmodmap
    xorg.xwininfo
    zlib-ng
    # nvidia-vaapi-driver
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  programs.labwc.enable = true;
  programs.niri.enable = true;
  programs.labwc.package = pkgs.unstable.labwc;
  programs.xwayland.enable = true;
  programs.criu.enable = true;
  programs.noisetorch.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.fish.enable = false;
  programs.zsh.enable = true;
  programs.wshowkeys.enable = true;
  programs.virt-manager.enable = true;

  programs.wayfire = {
    enable = false;
    plugins = (
      with pkgs.wayfirePlugins;
      [
        wcm
        wf-shell
        wayfire-plugins-extra
      ]
    );
  };

  programs.steam = {
    enable = true;
    # fontPackages = with pkgs; [
    #   wqy_zenhei
    #   liberation_ttf
    #   wqy_microhei
    #   noto-fonts-cjk-sans
    #   noto-fonts-cjk-serif
    # ];

    # extraProfile = "export STEAM_FORCE_DESKTOPUI_SCALING=2";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

  programs.kdeconnect = {
    enable = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      glibc
      glibc_multi
      wayland
      vulkan-loader
      # cudaPackages.cuda_cudart
      mpv
      sqlite
      libaio
      pcsclite
      libxml2
      fuse3
      fuse
      libgcc
      gcc-unwrapped.lib
      libgccjit
      libgit2
      boost
      libevent
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libcxx
      libGL
      libappindicator-gtk3
      libdrm
      libkrb5
      libnotify
      libpulseaudio
      libuuid
      libusb1
      libxkbcommon
      mesa
      nspr
      nss
      pango
      systemd
      icu
      openssl
      xcb-util-cursor
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libxkbfile
      xorg.libXrandr
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libxshmfence
      xorg.libXtst
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilrenderutil
      xorg.xcbutilkeysyms
      xorg.xcbutilerrors
      xorg.xcbutil

      zlib-ng
    ];
  };
  programs.htop.enable = true;
  programs.mosh.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  # xdg.portal = {
  #   enable = true;
  # };

  systemd = {
    services = {
      NetworkManager-dispatcher.enable = lib.mkForce false;
      sunshine = {
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          User = "root";
          ExecStart = "${pkgs.sunshine}/bin/sunshine";
        };
      };
      # disable_cpu_turbo = {
      #   wantedBy = [ "sysinit.target" ];
      #   serviceConfig = {
      #     Type = "oneshot";
      #     User = "root";
      #     ExecStart = ''/bin/sh -c "echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
      #     ExecStop = ''/bin/sh -c "echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
      #     RemainAfterExit = true;
      #   };
      # };
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

}
