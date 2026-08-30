pkgs: {
  min = pkgs.callPackage ./min-browser { };
  wpewebkit = pkgs.callPackage ./wpewebkit { };
}
