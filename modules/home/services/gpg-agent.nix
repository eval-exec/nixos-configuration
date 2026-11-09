{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    defaultCacheTtl = 600;
    pinentry.package = pkgs.pinentry-qt;
    extraConfig = ''
      allow-emacs-pinentry
    '';
  };

  # pinentry-qt also installs pinentry, pinentry-curses, and pinentry-tty.
  # A second pinentry package collides on those names in the user profile.
  home.packages = with pkgs; [
    gnupg
    pinentry-qt
  ];
}
