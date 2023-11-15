# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# test suda sudoa
{ config, pkgs, inputs, lib, emacs-overlay, ... }: {
  imports = [
    # Include the results of the hardware scan.
    # ./hardware-configuration.nix
    # <home-manager/nixos>
    ./cachix.nix
    ./g810-led.nix
  ];

  # sops = {
  #   gnupg = {
  #     home = "/home/exec/.gnupg";
  #     sshKeyPaths = [ ];
  #   };
  #   defaultSopsFile = ./secrets.yaml;
  #   secrets."google/execvy/application_password" = {
  #     owner = config.users.users.nobody.name;
  #     group = config.users.users.nobody.group;
  #   };
  # };

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
      useTmpfs = false;
      # tmpfsSize = "50%";
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
    };
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
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-chinese-addons
        fcitx5-with-addons
        fcitx5-configtool
        fcitx5-gtk
      ];
    };

  };
  # specialisation = {
  #   internal_nvidia = {
  #     configuration = { services.xserver.videoDrivers = [ "nvidia" ]; };
  #   };
  # };

  services = {
    keyd = {
      enable = false;
      keyboards.default.settings = {
        main = {
          capslock = "overload(control, esc)";
          leftcontrol = "overload(hyper, capslock)";
        };
        "hyper:C-M-A" = { };
      };
    };
    # input-remapper = {
    #   enable = false;
    #   enableUdevRules = false;
    # };
    touchegg = {
      enable = true;

    };

    acpid = {
      enable = true;
      logEvents = true;
    };

    logind.extraConfig = ''
      RuntimeDirectorySize=16G
    '';

    # Enable the X11 windowing system.
    thermald.enable = true;

    # services.nix-serve = {
    #   enable = true;
    #   # secretKeyFile = "/var/cache-priv-key.pem";
    # };

    # udev = { extraRules = "\n"; };

    resolved = {
      enable = false;
      fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
    };

    # Configure keymap in X11
    xserver = {
      enable = true;
      layout = "us";
      # xkbVariant = "";
      xkbOptions = "ctrl:hyper_capscontrol";

      videoDrivers = [ "nvidia" ];
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
      libinput.enable = true;
      libinput.touchpad.naturalScrolling = true;
      libinput.touchpad.scrollMethod = "twofinger";
      libinput.touchpad.disableWhileTyping = true;
      libinput.touchpad.accelSpeed = "0.5"; # null

      # Enable the KDE Plasma Desktop Environment.
      displayManager = {
        sddm = {
          enable = true;
          enableHidpi = true;
        };
        setupCommands = "";
        # sessionCommands run before setupCommands
        autoLogin = {
          enable = false;
          user = "exec";
        };
      };
      desktopManager.plasma5.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  security = {
    rtkit.enable = true;
    pam.services.sddm.enableKwallet = true;
    pam.services.kdewallet = {
      name = "kdewallet";
      enableKwallet = true;
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.exec = {
    isNormalUser = true;
    description = "exec";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" ];
    packages = with pkgs; [ firefox kate neofetch ];
  };
  users.defaultUserShell = pkgs.zsh;
  virtualisation = {
    libvirtd.enable = false;
    virtualbox.host.enable = true;
    virtualbox.host.enableExtensionPack = false;
    virtualbox.guest.enable = false;
    virtualbox.guest.x11 = false;
    docker.enable = true;
    # docker.rootless = {
    #   enable = false;
    #   setSocketVariable = true;
    # };
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
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      anonymousPro
      dejavu_fonts
      dina-font
      fira-code
      fira-code-symbols
      iosevka
      jetbrains-mono
      julia-mono
      liberation_ttf
      maple-mono
      maple-mono-NF
      maple-mono-SC-NF
      mplus-outline-fonts.githubRelease
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-extra
      open-sans
      proggyfonts
      sarasa-gothic
      source-han-sans
      source-han-serif
      symbola
      twitter-color-emoji
      unifont
      vistafonts-chs
      wqy_microhei
      wqy_zenhei
    ];
    fontconfig = {
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
         <alias>
           <family>sans-serif</family>
           <prefer>
             <family>Noto Sans</family>
             <family>Noto Color Emoji</family>
             <family>Noto Emoji</family>
             <family>DejaVu Sans</family>
           </prefer> 
         </alias>

         <alias>
           <family>serif</family>
           <prefer>
             <family>Noto Serif</family>
             <family>Noto Color Emoji</family>
             <family>Noto Emoji</family>
             <family>DejaVu Serif</family>
           </prefer>
         </alias>

         <alias>
          <family>monospace</family>
          <prefer>
            <family>Noto Mono</family>
            <family>Noto Color Emoji</family>
            <family>Noto Emoji</family>
           </prefer>
         </alias>
        </fontconfig>
      '';
      defaultFonts = {
        serif = [ "Serif" "Noto Sans CJK SC" "Sarasa Gothic SC" ];
        sansSerif = [ "Sans Serif" "Noto Sans CJK SC" "Sarasa Gothic SC" ];
        monospace = [ "JuliaMono" "Jetbrains Mono" ];
        emoji = [ "Noto Color Emoji" "Twitter Color Emoji" ];
      };
    };

  };

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    };
    localBinInPath = true;
    pathsToLink = [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "openssl-1.1.1w" "electron-24.8.6" ];
    };

    # overlays = [ emacs-overlay.overlay ];
  };

  environment.systemPackages = with pkgs; [
    appimage-run
    cachix
    clang
    discord
    docker-compose
    dua
    duf
    file
    git
    gnumake
    libclang
    libcxx
    libvterm
    lldb
    ncurses
    neovim
    nodejs
    openssl
    openssl_1_1
    pciutils
    pinentry-curses
    pinentry-emacs
    pinentry-qt
    pkg-config
    polkit
    proxychains-ng
    python3
    qemu
    steam-run
    sysfsutils
    tdesktop
    tdrop
    tree
    vim
    wakatime
    wget
    zlib
    # nvidia-vaapi-driver
  ];
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "exec" ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];

      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
      ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

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
  system.stateVersion = "23.05"; # Did you read the comment?

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [ wqy_zenhei wqy_microhei ];

      extraProfile = "export STEAM_FORCE_DESKTOPUI_SCALING=2";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "qt";
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      fuse3
      fuse
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
      libcxxabi
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
      openssl_1_1
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
  programs.mosh.enable = true;

  systemd = {
    services = {
      disable_cpu_turbo = {
        wantedBy = [ "sysinit.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = ''
            /bin/sh -c "echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
          ExecStop = ''
            /bin/sh -c "echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
          RemainAfterExit = true;

        };
      };
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

}
