{
  config,
  pkgs,
  ...
}: {
  imports = [
    "hyprland"
  ];

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.hidpi = true;
}
