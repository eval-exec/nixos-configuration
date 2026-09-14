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

  hardware.nvidia-container-toolkit.enable = false;

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
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;
  boot.extraModulePackages = [
  ];
  boot.kernelModules = [
    "kvm-intel"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  boot.blacklistedKernelModules = [
    "nouveau"
    "xe"
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/80296411-3bbc-4222-a884-f123a39cb6a8";
  boot.kernelParams = [
    "xe.force_probe=0"
    "i915.force_probe=*"
    "i915.enable_fbc=1"
    "i915.enable_guc=3"
    "i915.enable_psr=1"
    "i915.enable_psr2_sel_fetch=1"
    "intel_idle.max_cstate=9"
    "laptop_mode=1"
    "maxcpus=20"
    "nowatchdog"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    "processor.max_cstate=9"
    "rcu_nocbs=all"
    "rcutree.enable_rcu_lazy=1"
    "resume_offset=89067520"
    "vm.swappiness=0"
  ];
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=Y power_level=5 disable_11ac=1 disable_11ax=1 uapsd_disable=1
    options iwlmvm power_scheme=3
  '';
  boot.kernel.sysctl = {
    "vm.laptop_mode" = 5;
    "kernel.sysrq" = 1;
    "kernel.yama.ptrace_scope" = 0;
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
    {
      device = "/var/lib/swapfile";
      size = 128 * 1024;
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.powertop.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        FastConnectable = true;
        Experimental = true;
      };
    };
  };
  services.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver # LIBVA_DRIVER_NAME=iHD
    intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    libvdpau-va-gl
    intel-ocl
    nvidia-vaapi-driver
    intel-compute-runtime
    vpl-gpu-rt
    mesa
  ];
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    dynamicBoost.enable = true;
    modesetting.enable = true;
    powerManagement = {
      enable = true; # if true, nvidia cause kernel failed suspend
      finegrained = true;
    };
    nvidiaPersistenced = true;
    prime = {

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      nvidiaBusId = "PCI:1:0:0";

      intelBusId = "PCI:0:2:0";
    };
  };
  hardware.i2c.enable = true;

}
