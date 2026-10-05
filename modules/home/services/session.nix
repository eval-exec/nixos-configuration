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

    emacs = {
      Unit = {
        Description = "emacs";
        X-SwitchMethod = "keep-old";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = "DISPLAY";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 1;
        ExecStart = "${pkgs.nix}/bin/nix-shell ${config.home.homeDirectory}/.config/emacs/default.nix --run ${config.home.homeDirectory}/Projects/github.com/emacs-mirror/build/bin/emacs";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
