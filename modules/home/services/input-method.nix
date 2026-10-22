{ pkgs, ... }:
{
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
      ];
    };
  };
}
