{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # the ESP is only 511M and each cachyos v4 lto kernel+initrd is ~60M,
        # so cap the number of boot entries to keep it from filling up
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
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
    man.cache.enable = false;
  };

  time.timeZone = "Asia/Shanghai";

  i18n = {
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
      LC_TIME = "C.UTF-8";
    };

    # input method (fcitx5 + vinput) is managed by home-manager:
    # modules/home/services/input-method.nix
  };
}
