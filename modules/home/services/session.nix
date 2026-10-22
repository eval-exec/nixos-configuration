{ config, pkgs, ... }:
{
  systemd.user.services = {
    terminal-daemon = {
      Unit = {
        After = [ "tmux.target" ];
        X-SwitchMethod = "keep-old";
        Description = "terminal daemon";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Restart = "always";
        RestartSec = 1;
        ExecStart = "${pkgs.kitty}/bin/kitty --title=main --start-as=maximized tmux a";
      };
    };

    tmux = {
      Unit = {
        Description = "tmux";
        X-SwitchMethod = "keep-old";
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Type = "forking";
        ExecStart = "${pkgs.unstable.tmux}/bin/tmux new-session -d";
        ExecStop = "${pkgs.unstable.tmux}/bin/tmux kill-server";
        Restart = "always";
        RestartSec = 1;
      };
    };

  };
}
