{ pkgs, ... }:
{
  services.scx = {
    enable = false;
    scheduler = "scx_bpfland";
  };

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

    acpid = {
      enable = true;
      logEvents = true;
      acEventCommands = ''
                echo AC adapter event: $1
                vals=($1)  # space separated string to array of multiple values
                case ''${vals[3]} in
                  00000001)
                    echo plugged in
                    ${pkgs.linuxPackages.cpupower}/bin/cpupower frequency-set -g performance
                    ${pkgs.linuxPackages.cpupower}/bin/cpupower set all -b 0 --epp performance
        	    echo performance > /sys/firmware/acpi/platform_profile
                    ;;
                  00000000)
                    echo unplugged
                    ${pkgs.linuxPackages.cpupower}/bin/cpupower frequency-set -g powersave
                    ${pkgs.linuxPackages.cpupower}/bin/cpupower set all -b 15 --epp power
                    echo disable turbo...
                    echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
        	    echo quiet > /sys/firmware/acpi/platform_profile
                    echo disable turbo done
                    ;;
                  *)
                    echo unknown acpi event
                    ;;
                esac
      '';
    };

    logind.settings.Login = {
      RuntimeDirectorySize = "16G";
    };

    thermald.enable = false;
    thermald.debug = false;
  };
}
