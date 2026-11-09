{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  home.packages = with pkgs; [
    gnupg
    pinentry-qt
    pinentry-curses
    pinentry-emacs
  ];
}
