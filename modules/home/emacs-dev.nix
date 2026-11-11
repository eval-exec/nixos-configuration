{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # A nix file, not the built shell. Entering `gnu-emacs-dev` is what realizes
  # the build inputs. Depending on the shell derivation here would fetch them
  # during home-manager activation.
  shellNix = pkgs.writeText "emacs-dev-shell-entry.nix" ''
    let
      flake = builtins.getFlake "${inputs.self.outPath}";
      pkgs = flake.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    import ${./emacs-dev-shell.nix} {
      inherit pkgs;
      homeDirectory = "${config.home.homeDirectory}";
    }
  '';
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "gnu-emacs-dev" ''
      exec nix-shell ${shellNix}
    '')
  ];
}
