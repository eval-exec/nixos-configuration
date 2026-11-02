{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  noctalia = lib.getExe config.programs.noctalia.package;
  umbriel = lib.getExe config.programs.umbriel.package;

  # Toggle a scratchpad holding an application window. An already-running
  # window is adopted instead of spawning a second instance; the pad's
  # spawn_when_empty is only a last resort when the app has no window.
  # Since only one pad can be visible per output, a stack remembers displaced
  # pads so hiding the current one brings back the one underneath.
  toggleApp = pkgs.writeShellScript "umbriel-toggle-app" ''
    set -eu
    umb="${umbriel}"
    jq="${pkgs.jq}/bin/jq"
    pad="$1"
    app="$2"
    stack="''${XDG_RUNTIME_DIR:-/tmp}/umbriel-toggle-pad-stack"
    : >> "$stack"

    visible=$("$umb" windows --json | "$jq" -r --arg pad "$pad" '[.[] | select(.scratchpad == $pad and .visible)] | length')
    if [ "$visible" -gt 0 ]; then
      "$umb" msg scratchpad-toggle "$pad"
      # Restore the pad underneath, skipping pads whose windows are gone.
      while [ -s "$stack" ]; do
        prev=$(tail -n 1 "$stack")
        sed -i '$d' "$stack"
        [ -n "$prev" ] || continue
        prev_members=$("$umb" windows --json | "$jq" -r --arg pad "$prev" '[.[] | select(.scratchpad == $pad)] | length')
        [ "$prev_members" -gt 0 ] || continue
        prev_visible=$("$umb" windows --json | "$jq" -r --arg pad "$prev" '[.[] | select(.scratchpad == $pad and .visible)] | length')
        if [ "$prev_visible" -eq 0 ]; then
          "$umb" msg scratchpad-toggle "$prev"
        fi
        break
      done
      exit 0
    fi

    # Showing this pad: drop it from the stack, then remember the pad that is
    # currently visible (it goes underneath).
    current=$("$umb" windows --json | "$jq" -r '[.[] | select(.scratchpad != "" and .visible) | .scratchpad] | first // empty')
    tmp="$stack.tmp"
    grep -vxF "$pad" "$stack" > "$tmp" || true
    mv "$tmp" "$stack"
    if [ -n "$current" ] && [ "$current" != "$pad" ]; then
      grep -vxF "$current" "$stack" > "$tmp" || true
      mv "$tmp" "$stack"
      printf '%s\n' "$current" >> "$stack"
    fi

    members=$("$umb" windows --json | "$jq" -r --arg pad "$pad" '[.[] | select(.scratchpad == $pad)] | length')
    if [ "$members" -gt 0 ]; then
      exec "$umb" msg scratchpad-toggle "$pad"
    fi

    existing=$("$umb" windows --json | "$jq" -r --arg app "$app" '[.[] | select(.app_id == $app and .scratchpad == "")][0].id // empty')
    if [ -n "$existing" ]; then
      "$umb" msg window-focus "$existing"
      "$umb" msg window-move-to-scratchpad "$pad"
      exec "$umb" msg scratchpad-toggle "$pad"
    fi

    exec "$umb" msg scratchpad-toggle "$pad"
  '';
in
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.umbriel.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    # Umbriel starts the shell only for its own session, leaving Plasma usable.
    systemd.enable = false;
    settings = {
      shell = {
        font_family = "Noto Sans";
        polkit_agent = true;
        launch_apps_as_systemd_services = true;
      };
      theme.templates.builtin_ids = [ "umbriel" ];
    };
  };

  programs.umbriel.enable = true;

  # Store-backed: edit modules/home/umbriel.toml, then `make switch-hm-fast`.
  xdg.configFile."umbriel/config.toml".source = ./umbriel.toml;

  home.file.".local/bin/umbriel-toggle-app".source = toggleApp;
}
