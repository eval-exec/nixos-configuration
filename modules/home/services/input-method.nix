{ pkgs, inputs, ... }:
let
  vinput = inputs.fcitx5-vinput.packages.${pkgs.system}.default;
in
{
  home.packages = [ vinput ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;

      addons = with pkgs; [
        fcitx5-rime
        qt6Packages.fcitx5-chinese-addons
        qt6Packages.fcitx5-with-addons
        qt6Packages.fcitx5-configtool
        fcitx5-gtk
        fcitx5-pinyin-zhwiki
        kdePackages.fcitx5-qt
        vinput
      ];
    };
  };

  # mirrors the unit shipped by the package, with ExecStart in the nix store
  systemd.user.services.vinput-daemon = {
    Unit = {
      Description = "Vinput Voice Input Daemon";
      After = [ "pipewire.service" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "org.fcitx.Vinput";
      ExecStart = "${vinput}/bin/vinput-daemon";
    };
  };
}
