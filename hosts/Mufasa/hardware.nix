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
    # rcu_nocbs offloads RCU callbacks to per-CPU rcuo[g,p]/N kthreads so they
    # cannot disturb CPUs reserved via isolcpus/nohz_full. Neither of those is
    # set here, so it bought no isolation while every callback wakeup became a
    # cross-CPU interrupt: measured rcuop/0 context-switching 4868x/s against
    # 1.1/s for scx_lavd, accounting for ~95% of idle IRQs (IWI 2026/s + LOC
    # 1504/s out of 3698/s total) at 23.6W. rcu_lazy is kept -- it reduces RCU
    # wakeups rather than adding them.
    "rcutree.enable_rcu_lazy=1"
    "resume_offset=89067520"
    "vm.swappiness=0"
  ];
  # iwlwifi.uapsd_disable is a bitmap (1: BSS, 2: P2P client) that defaults to 3,
  # i.e. U-APSD off everywhere. 0 enables WMM power save on both. The previous
  # value of 1 left BSS (the infrastructure link that matters on a laptop) off.
  # 11ac/11ax are left at their defaults: VHT/HE shorten airtime and 11ax adds
  # TWT, so disabling them to "save power" costs more than it saves.
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=Y power_level=5 uapsd_disable=0
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
    # NOTE: omitting nvidia-vaapi-driver here does nothing on its own -- the
    # nvidia module adds it back from hardware.nvidia.videoAcceleration, which
    # is disabled above. That option is the lever; this list is not.
    intel-compute-runtime
    vpl-gpu-rt
    mesa
  ];
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    # dynamicBoost runs nvidia-powerd, which only rebalances the power budget
    # between CPU and GPU while on AC. On battery it is just another daemon
    # holding the dGPU awake.
    dynamicBoost.enable = false;
    modesetting.enable = true;
    powerManagement = {
      enable = true; # if true, nvidia cause kernel failed suspend
      finegrained = true;
    };
    # nvidia-persistenced keeps /dev/nvidia* open for its entire lifetime, so
    # runtime_usage stays 1 and the GPU never enters runtime D3 -- which is
    # precisely what powerManagement.finegrained above is trying to achieve.
    # Measured with it enabled: runtime_suspended_time 958ms out of 3d17h
    # uptime, despite NVreg_DynamicPowerManagement=0x02 already being set.
    nvidiaPersistenced = false;
    # The real lever for keeping the dGPU asleep. nvidia.nix:705 does
    #   extraPackages = lib.optional cfg.videoAcceleration pkgs.nvidia-vaapi-driver
    # so listing nothing in hardware.graphics.extraPackages is NOT enough --
    # the module re-adds it. With nvidia_drv_video.so exported, VA-API
    # enumeration opens /dev/nvidia0 and pins runtime_usage=1.
    # Measured: plasmashell held 31 nvidia fds and runtime_suspended_time was
    # 0ms across a full uptime, on a fresh boot, reproducibly.
    videoAcceleration = false;
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
