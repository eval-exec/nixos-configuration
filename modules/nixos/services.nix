{ config, pkgs, ... }:
{
  services.gpsd = {
    enable = true;
    devices = [
      "/dev/ttyACM0"
    ];
  };

  services = {
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
      enable = true;
      useXkbConfig = true;
      extraConfig = ''
        font-size=18
      '';
      fonts = [
        {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }
      ];
    };

    fwupd.enable = false;

    samba = {
      enable = false;
      settings = {
        public = {
          path = "${config.users.users.${config.users.primaryUser}.home}/Temp/samba";
          browseable = true;
          writable = true;
          printable = false;
          createMask = "0777";
        };
      };
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

    resolved = {
      enable = false;
      settings.Resolve.FallbackDNS = "1.1.1.1 8.8.8.8";
    };

    wyoming = {

      piper = {
        servers = {
          "default" = {
            enable = true;
            voice = "en-us-ryan-medium";
            uri = "tcp://0.0.0.0:10200";
            speaker = 0;
          };
        };
      };
    };
  };
}
