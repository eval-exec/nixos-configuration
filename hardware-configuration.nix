# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.consoleLogLevel = 7;
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.resumeDevice = "/dev/disk/by-uuid/80296411-3bbc-4222-a884-f123a39cb6a8";
  boot.kernelParams = [
    "resume_offset=196851712"
    # "video=eDP-1:3456x2160@60"
    "mem_sleep_default=deep"
    # "i915.enable_psr=0"
    # "i915.fastboot=1"
    # "i915.enable_guc=3"
    "intel_idle.max_cstate=1"
    # "amdgpu.ppfeaturemask=0xffffffff"
    # "amdgpu.aspm=0"
  ];
  boot.extraModulePackages = [ ];
  boot.kernel.sysctl = {
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
      size = 96 * 1024;
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
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  hardware.enableAllFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  # # nixpkgs.config.packageOverrides = pkgs: {
  # #   vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  # # };
  # hardware.opengl.extraPackages = with pkgs; [ intel-media-driver ];
  # hardware.opengl.extraPackages32 = with pkgs; [ intel-media-driver ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    nvidiaPersistenced = true;
    prime = {
      sync.enable = true;

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";
    };
  };
  hardware.i2c.enable = true;
}
