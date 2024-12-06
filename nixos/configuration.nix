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
let
  wallpaper-engine-kde-plugin =
    with pkgs;
    stdenv.mkDerivation rec {
      pname = "wallpaperEngineKde";
      version = "066813c4309faf1a86b5bc54bdaa69b4d7e511ed";
      src = fetchFromGitHub {
        owner = "catsout";
        repo = "wallpaper-engine-kde-plugin";
        rev = version;
        hash = "sha256-KFTYZM82tQOQ+EKcPZPcsv0I9opqR2ahUTFjeKXmcVc=";
        fetchSubmodules = true;
      };
      nativeBuildInputs = with kdePackages; [
        cmake
        extra-cmake-modules
        glslang
        pkg-config
        qt6.full
        gst_all_1.gst-libav
        shaderc
        ninja # qwrapQtAppsHook
      ];
      buildInputs =
        [
          mpv
          lz4
          vulkan-headers
          vulkan-tools
          vulkan-loader
        ]
        ++ (
          with kdePackages;
          with qt6Packages;
          [
            qtbase
            # plasma-sdk
            kpackage
            kdeclarative
            # libplasma
            # plasma-workspace
            # kde-dev-utils
            plasma5support
            qt5compat
            qtwebsockets
            qtwebengine
            qtwebchannel
            qtmultimedia
            qtdeclarative
          ]
        )
        ++ [ (python3.withPackages (python-pkgs: [ python-pkgs.websockets ])) ];
      cmakeFlags = [ "-DUSE_PLASMAPKG=OFF" ]; # "-DCMAKE_BUILD_TYPE=Release" "-DBUILD_QML=ON" "-DQT_MAJOR_VERSION=6" ];
      dontWrapQtApps = true;
      postPatch = ''
        rm -rf src/backend_scene/third_party/glslang
        ln -s ${glslang.src} src/backend_scene/third_party/glslang
      '';
      #Optional informations
      meta = with lib; {
        description = "Wallpaper Engine KDE plasma plugin";
        homepage = "https://github.com/Jelgnum/wallpaper-engine-kde-plugin";
        license = licenses.gpl2Plus;
        platforms = platforms.linux;
      };
      # Not work yet
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/libraries/applet-window-buttons/default.nix#L20
      # applet-window-buttons6 =
      #   with pkgs;
      #   libsForQt5.applet-window-buttons.overrideAttrs (old: rec {
      #     version = "a7b95da32717b90a1d9478db429d6fa8a6c4605f";
      #     # https://github.com/moodyhunter/applet-window-buttons6
      #     src = fetchFromGitHub {
      #       owner = "moodyhunter";
      #       repo = "applet-window-buttons6";
      #       rev = version;
      #       hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      #     };
      #     patches = [ ];
      #   });
    };
in
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

      settings = {

        auto-optimise-store = true;
        trusted-users = [
          "root"
          "exec"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        ];

        substituters = [
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          # "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://devenv.cachix.org"
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
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';

    tmp = {
      useTmpfs = true;
      tmpfsSize = "24G";
      cleanOnBoot = true;
    };
  };
  console.useXkbConfig = true;

  documentation = {
    enable = true;
    dev.enable = true;
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
      enabled = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-rime
          fcitx5-chinese-addons
          fcitx5-with-addons
          fcitx5-configtool
          fcitx5-gtk
          libsForQt5.fcitx5-qt
        ];
      };
    };
  };
  # specialisation = {
  #   internal_nvidia = {
  #     configuration = { services.xserver.videoDrivers = [ "nvidia" ]; };
  #   };
  # };

  services = {
    fwupd.enable = true;
    desktopManager = {
      plasma6.enable = true;
    };

    samba = {
      enable = true;
      shares = {
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
      enable = false;
    };
    fprintd = {
      enable = false;
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
    };

    logind.extraConfig = ''
      RuntimeDirectorySize=16G
    '';

    thermald.enable = true;
    thermald.debug = true;

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

      sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = false;
        user = "exec";
      };
    };

    libinput.enable = false;
    # libinput.touchpad.naturalScrolling = true;
    # libinput.touchpad.scrollMethod = "twofinger";
    # libinput.touchpad.disableWhileTyping = true;
    # libinput.touchpad.accelSpeed = "0.6"; # null

    # Configure keymap in X11
    xserver = {
      enable = true;
      # synaptics.enable = true;
      #       xkb = {
      #         model = "pc104";
      #         layout = "us";
      #         variant = "";
      #         options = "ctrl:nocaps";
      #         extraLayouts = {
      #           ctrl = {
      #             description = "Caps as Ctrl, Ctrl as Hyper as Mod3";
      #             languages = [ "eng" ];
      #             symbolsFile = pkgs.writeText "ctrl" ''
      #               // Eliminate CapsLock, making it another Ctrl.
      #               partial modifier_keys
      #               xkb_symbols "nocaps" {
      #                   replace key <CAPS> { [ Control_L ], type[group1] = "ONE_LEVEL" };
      #                   modifier_map Control { <CAPS> };
      #
      #                   modifier_map Mod4 { Super_L, Super_R };
      #
      #                   key <SUPR> {    [ NoSymbol, Super_L ]   };
      #                   modifier_map Mod4   { <SUPR> };
      #
      #                   replace key <LCTL> { [ Hyper_L ] };
      #                   modifier_map Mod3    { <LCTL> };
      #
      #                   key <HYPR> {    [ NoSymbol, Hyper_L ]   };
      #                   modifier_map Mod3   { <HYPR> };
      #               };
      #             '';
      #           };
      #         };
      #       };

      # videoDrivers = [ "nvidia" ];

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
        gdm.enable = false;
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

      faster-whisper = {

        servers = {
          "default" = {
            enable = true;
            model = "medium.en";
            uri = "tcp://0.0.0.0:10300";
            language = "en";
          };
        };
      };
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
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = false;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  security = {
    rtkit.enable = true;
    pam.services.sddm.enableKwallet = true;
    pam.services.kdewallet = {
      name = "kdewallet";
      enableKwallet = true;
    };
    sudo = {
      extraRules = [
        {
          commands = [
            {
              command = "/run/current-system/sw/bin/renice";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
    };
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
      "vboxusers"
    ];
    packages = with pkgs; [
      firefox
      kate
    ];
  };
  users.defaultUserShell = pkgs.zsh;
  virtualisation = {
    libvirtd.enable = true;
    # xen.enable = false;
    # waydroid.enable = false;

    virtualbox = {
      host = {
        enable = true;
        # package = pkgs-stable.virtualbox;
        # enableExtensionPack = true;
      };
      guest.enable = false;
    };
    docker = {
      enable = true;
    };
    vmware = {
      host = {
        enable = false;
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
    enableDefaultPackages = false;
    packages = with pkgs; [
      iosevka
      jetbrains-mono
      libre-caslon
      julia-mono
      powerline-fonts
      powerline-symbols
      liberation_ttf
      nerdfonts
      # noto-fonts
      # google-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # noto-fonts-lgc-plus
      noto-fonts-emoji
      twitter-color-emoji
      # unicode-emoji
      # noto-fonts-extra
      sarasa-gothic
      source-code-pro
      source-han-sans
      source-han-serif
      symbola
      unifont
      vistafonts-chs
      vistafonts-chs
      vistafonts
      material-icons
      # material-design-icons
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
          "Twitter Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
          "Twitter Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
          "Twitter Color Emoji"
          "Noto Sans Egyptian Hieroglyphs"
        ];
      };
      # localConf = ''
      #   <?xml version='1.0' encoding='UTF-8'?>
      #   <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      #   <fontconfig>
      #    <alias>
      #     <family>serif</family>
      #     <prefer>
      #      <family>Noto Sans</family>
      #      <family>Noto Color Emoji</family>
      #     </prefer>
      #    </alias>
      #    <alias>
      #     <family>sans-serif</family>
      #     <prefer>
      #      <family>Noto Sans</family>
      #      <family>Noto Color Emoji</family>
      #     </prefer>
      #    </alias>
      #    <alias>
      #     <family>monospace</family>
      #     <prefer>
      #      <family>Noto Sans</family>
      #      <family>Noto Color Emoji</family>
      #     </prefer>
      #    </alias>
      #    <dir>~/.fonts</dir>
      #    <match target="font">
      #     <edit name="hinting" mode="assign">
      #      <bool>true</bool>
      #     </edit>
      #    </match>
      #    <match target="font">
      #     <edit name="hintstyle" mode="assign">
      #      <const>hintslight</const>
      #     </edit>
      #    </match>
      #   </fontconfig>
      # '';
    };
  };

  environment = {
    # sessionVariables = {
    #   LIBVA_DRIVER_NAME = "iHD";
    # };
    variables = {
      # XKB_DEFAULT_LAYOUT = "us";
      # NIXOS_OZONE_WL = "1";
      # GDK_BACKEND = "wayland";
      OLLAMA_HOST = "http://127.0.0.1:11434";
      GTK_IM_MODULE = lib.mkForce "";
      QT_IM_MODULE = lib.mkForce "";
      EDITOR = "nvim";
      VISUAL = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    };
    localBinInPath = true;
    pathsToLink = [ ];
  };

  environment.systemPackages = with pkgs; [
    linuxHeaders
    libsForQt5.xdg-desktop-portal-kde
    kdePackages.kde-gtk-config
    # libinput
    kdePackages.qtvirtualkeyboard
    kdePackages.discover
    xdg-desktop-portal
    xdg-utils
    xdg-desktop-portal-wlr
    appimage-run
    cachix
    clang
    (aspellWithDicts (
      ds: with ds; [
        en
        en-computers
        en-science
      ]
    ))
    docker-compose
    # wallpaper-engine-kde-plugin
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default

    qt6.qtwebsockets
    kdePackages.qtwebsockets
    wayland-utils
    vulkan-tools
    kdePackages.qtmultimedia
    gst_all_1.gst-libav
    # (python3.withPackages (python-pkgs: [ python-pkgs.websockets ]))
    dua
    duf
    file
    git
    gnome.gnome-tweaks
    glibcInfo
    gnumake
    interception-tools
    libclang
    libcxx
    libvterm
    linux-manual
    lldb
    man-pages-posix
    man-pages-posix
    wireplumber
    ncurses
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
    stdman
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
    zlib
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
  system.stateVersion = "24.11"; # Did you read the comment?

  programs.xwayland.enable = true;
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
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          wqy_zenhei
          liberation_ttf
          wqy_microhei
        ];

      extraProfile = "export STEAM_FORCE_DESKTOPUI_SCALING=2";
    };
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
      # cudaPackages.cuda_cudart
      mpv
      sqlite
      libaio
      pcsclite

      libxml2
      fuse3
      fuse
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
      pipewire
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

      zlib
    ];
  };
  programs.htop.enable = true;
  programs.mosh.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

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
      disable_cpu_turbo = {
        wantedBy = [ "sysinit.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = ''/bin/sh -c "echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
          ExecStop = ''/bin/sh -c "echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
          RemainAfterExit = true;
        };
      };
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  # system.activationScripts = {
  #   wallpaper-engine-kde-plugin.text = ''
  #     wallpaperenginetarget=share/plasma/wallpapers/com.github.catsout.wallpaperEngineKde
  #     ln -s ${wallpaper-engine-kde-plugin}/$wallpaperenginetarget /home/exec/.local/$wallpaperenginetarget
  #   '';
  # };
}
