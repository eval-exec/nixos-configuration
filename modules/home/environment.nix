{ config, pkgs, ... }:
{
  home.sessionVariables = {
    EMACS_TELEGA_SERVER_LIB_PREFIX = "${pkgs.unstable.tdlib}";
    CGO_ENABLED = "1";
    GO111MODULE = "auto";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.exec/bin"
    "${config.home.homeDirectory}/.moon/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/.cargo/bin"
    "${config.home.homeDirectory}/.zvm/bin"
    "${config.home.homeDirectory}/go/bin"
  ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Sans Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}
