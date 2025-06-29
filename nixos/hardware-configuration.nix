# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...

}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.consoleLogLevel = 7;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [
    # pkgs.linuxPackages_latest.v4l2loopback
  ];
  boot.kernelModules = [
    "kvm-intel"
    # "snd_aloop"
    "nvidia_uvm"
  ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.resumeDevice = "/dev/disk/by-uuid/80296411-3bbc-4222-a884-f123a39cb6a8";
  # boot.kernelPatches = [
  #   {
  #     name = "max-hibernate-compress-speed";
  #     patch = ./0001-Hack-hibernate-speedup.patch ;
  #   }
  # ];
  boot.kernelParams = [
    "nowatchdog"
    "mem_sleep_default=deep"
    "resume_offset=89067520"
    "maxcpus=20"
    # "video=eDP-1:3456x2160@60"
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
    "i915.enable_psr2_sel_fetch=1"
    "i915.enable_guc=3"
    "intel_idle.max_cstate=9"
  ];
  # options snd-intel-dspcfg dsp_driver=1
  # options snd-hda-intel model=generic
  boot.extraModprobeConfig = '''';
  boot.kernel.sysctl = {
    "vm.laptop_mode" = 5;
    "kernel.sysrq" = 1;
    "fs.inotify.max_user_watches" = 524288;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/80296411-3bbc-4222-a884-f123a39cb6a8";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B564-E5E7";
    fsType = "vfat";
  };

  fileSystems."/home/exec/box" = {
    device = "/dev/disk/by-uuid/ccb303b5-dcc3-4298-b307-7843f27cd771";
    fsType = "ext4";
  };

  swapDevices = [
    # { device = "/dev/disk/by-uuid/5dd32dc4-e574-41b8-b0e0-3a6385924b79"; }
    {
      device = "/var/lib/swapfile";
      size = 128 * 1024;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp58s0u1u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp59s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.powertop.enable = false;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.bluetooth = {
    enable = true;
    # package = pkgs.bluez-experimental; # This will now use our custom bluez from the overlay
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        # Enable = "Source,Sink,Media,Socket";
        FastConnectable = true;
        Experimental = true;
      };
    };
  };
  # services.pulseaudio.enable = false;
  services.pulseaudio.package = pkgs.pulseaudioFull;
  # services.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];

  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  # # nixpkgs.config.packageOverrides = pkgs: {
  # #   vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  # # };
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver # LIBVA_DRIVER_NAME=iHD
    intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    libvdpau-va-gl
  ];
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
  hardware.nvidia = {
    open = true;
    # nvidiaSettings = false;
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    nvidiaPersistenced = true;
    prime = {
      # sync.enable = true;

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";
    };
  };
  hardware.i2c.enable = true;

}
