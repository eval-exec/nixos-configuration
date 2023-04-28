# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# test suda sudoa
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    # ./hardware-configuration.nix
    # <home-manager/nixos>
    ./clash.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "Mufasa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-configtool
      fcitx5-gtk
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
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

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;
  services.xserver.libinput.touchpad.scrollMethod = "twofinger";
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services.xserver.libinput.touchpad.accelSpeed = "0.5"; # null

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.exec = {
    isNormalUser = true;
    description = "exec";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      firefox
      kate
      neofetch
      #  thunderbird
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # home-manager = {
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  #   users.exec = import ./home.nix;
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  fonts.fonts = with pkgs; [
    nerdfonts
    symbola
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    unifont
  ];
  fonts.fontconfig.localConf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <alias binding="weak">
        <family>monospace</family>
        <prefer>
          <family>emoji</family>
        </prefer>
      </alias>
      <alias binding="weak">
        <family>sans-serif</family>
        <prefer>
          <family>emoji</family>
        </prefer>
      </alias>
      <alias binding="weak">
        <family>serif</family>
        <prefer>
          <family>emoji</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

  fonts.fontconfig.defaultFonts = {
    serif = ["Serif" "Noto Sans CJK SC"];
    sansSerif = ["Sans Serif" "Noto Sans CJK SC"];
    monospace = ["Jetbrains Mono"];
    emoji = ["Noto Color Emoji"]; # "Twitter Color Emoji" "JoyPixels" "Unifont" "Unifont Upper" ];
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
  environment.localBinInPath = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    clang
    discord
    docker-compose
    dua
    duf
    emacs
    gcc
    git
    gnumake
    google-chrome
    jetbrains.clion
    libclang
    libcxx
    ncurses
    neovim
    nodejs
    openssl
    pinentry-curses
    pinentry-emacs
    pinentry-qt
    pkg-config
    python3
    qv2ray
    tdesktop
    tdrop
    tree
    v2ray
    v2ray-geoip
    vim
    vscode
    vscode.fhs
    wakatime
    wget
    zlib
    libvterm
    appimage-run
    lldb
    steam-run
    file
    polkit
    sysfsutils
    pciutils
  ];

  nix.settings.substituters = ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
  nix.settings.experimental-features = ["nix-command" "flakes"];

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

  programs.kdeconnect.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # programs.vscode = {
  # 	enable = true;
  # 	package = pkgs.vscode.fhs;
  #
  # };
  # programs.vscode.package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    interactiveShellInit = ''
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
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
        "man"
        "grc"
      ];
      # theme = "mlh";
      customPkgs = [
        pkgs.nix-zsh-completions
      ];
    };
  };

  programs.proxychains = {
    enable = true;
    package = "pkgs.proxychains-ng";
    proxies = {
      myproxy = {
        type = "http";
        host = "127.0.0.1";
        port = 7890;
        enable = true;
      };
    };
  };

  # programs.nix-index.enable = true;

  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
