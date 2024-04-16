{ pkgs, host, ... }:

let
  inherit ( import ../../hosts/${host}/options.nix ) terminal browser;
in
pkgs.writeShellScriptBin "list-hypr-bindings" ''
  yad --width=925 --height=650 \
  --center \
  --fixed \
  --title="Hyprland Keybindings" \
  --no-buttons \
  --list \
  --column=Key: \
  --column=Description: \
  --column=Command: \
  --timeout=90 \
  --timeout-indicator=right \
  " = Windows/Super/CAPS LOCK" "Modifier Key, used for keybindings" "Doesn't really execute anything by itself." \
  " + ENTER" "Terminal" "${terminal}" \
  " + P" "Rofi App Launcher" "rofi -show drun" \
  " + SHIFT + Q" "Kill Focused Window" "killactive" \
  " + SHIFT + W" "Search Websites Like Nix Packages" "web-search" \
  " + W" "Launch Web Browser" "${browser}" \
  " + E" "Launch Emoji Selector" "emopicker9000" \
  " + B" "Hide waybar temporarily" "pkill -10 waybar" \
  " + SHIFT + B" "Restart waybar" "reset-waybar" \
  " + S" "Take Screenshot" "screenshootin" \
  " + D" "Launch webcord" "webcord" \
  " + M" "Launch Spotify" "spotify" \
  " + P" "Pseudo Tiling" "pseudo" \
  " + SHIFT + I" "Toggle Split Direction" "togglesplit" \
  " + F" "Toggle Focused Fullscreen" "fullscreen" \
  " + SHIFT + SPACE" "Toggle Focused Floating" "fullscreen" \
  " + SHIFT + E" "Quit / Exit Hyprland" "exit" \
  " + CTRL + Left" "Move Focused Window Left Monitor" "hyprctl dispatch 'split-changemonitor prev'" \
  " + CTRL + Right" "Move Focused Window to Right monitor" "hyprctl dispatch 'split-changemonitor next'" \
  " + MINUS" "Toggle Special Workspace" "togglespecialworkspace" \
  " + SHIFT + MINUS" "Send Focused Window To Special Workspace" "movetoworkspace,special" \
  " + 1-0" "Move To Workspace 1 - 10" "workspace,X" \
  " + SHIFT + 1-0" "Move Focused Window To Workspace 1 - 10" "movetoworkspace,X" \
  " + MOUSE_LEFT" "Move/Drag Window" "movewindow" \
  " + MOUSE_RIGHT" "Resize Window" "resizewindow" \
  "ALT + TAB" "Cycle Window Focus + Bring To Front" "cyclenext & bringactivetotop" \
  ""
''
