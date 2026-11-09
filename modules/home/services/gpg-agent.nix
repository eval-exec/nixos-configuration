{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  # pinentry-qt also installs pinentry, pinentry-curses, and pinentry-tty.
  # A second pinentry package collides on those names in the user profile.
  home.packages = with pkgs; [
    gnupg
    pinentry-qt
  ];
}
