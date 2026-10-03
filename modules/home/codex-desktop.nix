{ inputs, ... }:
{
  imports = [
    inputs.codex-desktop-linux.homeManagerModules.default
  ];

  programs.codexDesktopLinux = {
    enable = true;
  };
}
