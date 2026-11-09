{ pkgs, ... }:
{
  # kdeconnect's digitizer plugin needs /dev/uinput.
  hardware.uinput.enable = true;

  services.gpsd = {
    enable = true;
    devices = [
      "/dev/ttyACM0"
    ];
  };

  services = {
    atd.enable = true;
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
      term = "xterm-256color";
      extraConfig = ''
        font-engine=pango
        font-size=18
        sb-size=10000
        # kmscon session-control is disabled on real VTs; use tmux or
        # multiple VTs instead.

        # Use only the boot/display GPU (Intel i915); leave the NVIDIA 3D
        # controller untouched.
        gpus=primary

        # Default palette blue (0,0,238) has ~2:1 contrast on black.
        palette=custom
        palette-blue=97,175,239
        palette-light-blue=137,180,250
      '';
      fonts = [
        {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }
        {
          name = "DejaVu Sans Mono";
          package = pkgs.dejavu_fonts;
        }
        {
          name = "Noto Sans Mono CJK SC";
          package = pkgs.noto-fonts-cjk-sans;
        }
        {
          name = "Noto Emoji";
          package = pkgs.noto-fonts-monochrome-emoji;
        }
        {
          name = "Symbola";
          package = pkgs.symbola;
        }
      ];
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
