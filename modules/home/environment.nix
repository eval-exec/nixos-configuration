{ config, pkgs, ... }:
{
  home.sessionVariables = {
    EMACS_TELEGA_SERVER_LIB_PREFIX = "${pkgs.unstable.tdlib}";
    CGO_ENABLED = "1";
    GO111MODULE = "auto";
    FZF_CTRL_T_OPTS = "--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'";
    FZF_CTRL_R_OPTS = "--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'";
    FZF_ALT_C_OPTS = "--preview 'tree -C {}'";
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OLLAMA_HOST = "http://127.0.0.1:11434";
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
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif"
          "Noto Color Emoji"
          "Twitter Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Sans Egyptian Hieroglyphs"
        ];
      };
    };
  };
}
