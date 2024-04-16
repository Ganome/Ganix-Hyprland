{ pkgs, config, lib, inputs, host, ... }:

let
  theme = config.colorScheme.palette;
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
  inherit (import ../../hosts/${host}/options.nix) 
    browser cpuType gpuType
    wallpaperDir borderAnim
    theKBDLayout terminal
    theSecondKBDLayout
    theKBDVariant sdl-videodriver
    extraMonitorSettings;
in with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      hyprplugins.hyprtrails
    ];

    extraConfig = let
      modifier = "SUPER";
    in concatStrings [ ''
      #Split-Monitor-Workspaces Setup
      plugin {
        split-monitor-workspaces {
        count = 10 
        }
      }

      monitor=,preferred,auto,1
      ${extraMonitorSettings}
      general {
        gaps_in = 6
        gaps_out = 8
        border_size = 2
        col.active_border = rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg
        col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
        layout = dwindle
        resize_on_border = true
      }

      input {
        kb_layout = ${theKBDLayout}, ${theSecondKBDLayout}
	kb_options = grp:alt_shift_toggle
        kb_options=caps:super
        follow_mouse = 1
        touchpad {
          natural_scroll = false
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        accel_profile = flat
      }
      env = NIXOS_OZONE_WL, 1
      env = NIXPKGS_ALLOW_UNFREE, 1
      env = XDG_CURRENT_DESKTOP, Hyprland
      env = XDG_SESSION_TYPE, wayland
      env = XDG_SESSION_DESKTOP, Hyprland
      env = GDK_BACKEND, wayland
      env = CLUTTER_BACKEND, wayland
      env = SDL_VIDEODRIVER, ${sdl-videodriver}
      env = QT_QPA_PLATFORM, wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
      env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
      env = MOZ_ENABLE_WAYLAND, 1
      ${if cpuType == "vm" then ''
        env = WLR_NO_HARDWARE_CURSORS,1
        env = WLR_RENDERER_ALLOW_SOFTWARE,1
      '' else ''
      ''}
      ${if gpuType == "nvidia" then ''
        env = WLR_NO_HARDWARE_CURSORS,1
      '' else ''
      ''}
      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
      }
      misc {
        mouse_move_enables_dpms = true
        key_press_enables_dpms = false
      }
      animations {
        enabled = yes
        bezier = wind, 0.05, 0.9, 0.1, 1.05
        bezier = winIn, 0.1, 1.1, 0.1, 1.1
        bezier = winOut, 0.3, -0.3, 0, 1
        bezier = liner, 1, 1, 1, 1
        animation = windows, 1, 6, wind, slide
        animation = windowsIn, 1, 6, winIn, slide
        animation = windowsOut, 1, 5, winOut, slide
        animation = windowsMove, 1, 5, wind, slide
        animation = border, 1, 1, liner
        ${if borderAnim == true then ''
          animation = borderangle, 1, 30, liner, loop
        '' else ''
        ''}
        animation = fade, 1, 10, default
        animation = workspaces, 1, 5, wind
      }
      decoration {
        rounding = 10
        drop_shadow = false
        blur {
            enabled = true
            size = 5
            passes = 3
            new_optimizations = on
            ignore_opacity = on
        }
      }
      plugin {
        hyprtrails {
          color = rgba(${theme.base0A}ff)
        }
      }
      exec-once = $POLKIT_BIN
      exec-once = dbus-update-activation-environment --systemd --all
      exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = swww init
      exec-once = waybar
      exec-once = swaync
      exec-once = wallsetter
      exec-once = nm-applet --indicator
      exec-once = swayidle -w timeout 720 'swaylock -f' timeout 800 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f -c 000000'

      #Clipboard history with Super+V
      exec-once = wl-paste --type text --watch cliphist store 
      exec-once = wl-paste --type image --watch cliphist store

      dwindle {
        pseudotile = true
        preserve_split = true
      }
      master {
        new_is_master = true
      }
      bind = ${modifier},Return,exec,${terminal}
      bind = ${modifier},P,exec,rofi-launcher
      bind = ${modifier}SHIFT,W,exec,web-search
      ${if browser == "google-chrome" then ''
	bind = ${modifier},W,exec,google-chrome-stable
      '' else ''
	bind = ${modifier},W,exec,${browser}
      ''}
      bind = ${modifier},E,exec,emopicker9000
      bind = ${modifier},S,exec,screenshootin
      bind = ${modifier},D,exec,webcord
      bind = ${modifier},M,exec,spotify
      bind = ${modifier}SHIFT,Q,killactive,
#      bind = ${modifier},P,pseudo,
      bind = ${modifier}SHIFT,I,togglesplit,
      bind = ${modifier},F,fullscreen,
      bind = ${modifier}SHIFT,SPACE,togglefloating,
      bind = ${modifier}SHIFT,E,exit,
      
      #Waybar
      bind = ${modifier}, B, exec, pkill -10 waybar
      bind = ${modifier}SHIFT, B, exec, $HOME/.local/bin/reset-waybar

      # Special Workspaces - like scrathpad, but singular
      bind = ${modifier}SHIFT,MINUS,movetoworkspace,special
      bind = ${modifier},MINUS,togglespecialworkspace
      
      #Navigation
      bind = ${modifier},1,split-workspace,1
      bind = ${modifier},2,split-workspace,2
      bind = ${modifier},3,split-workspace,3
      bind = ${modifier},4,split-workspace,4
      bind = ${modifier},5,split-workspace,5
      bind = ${modifier},6,split-workspace,6
      bind = ${modifier},7,split-workspace,7
      bind = ${modifier},8,split-workspace,8
      bind = ${modifier},9,split-workspace,9
      bind = ${modifier},0,split-workspace,10
      bind = ${modifier}SHIFT,1,split-movetoworkspace,1
      bind = ${modifier}SHIFT,2,split-movetoworkspace,2
      bind = ${modifier}SHIFT,3,split-movetoworkspace,3
      bind = ${modifier}SHIFT,4,split-movetoworkspace,4
      bind = ${modifier}SHIFT,5,split-movetoworkspace,5
      bind = ${modifier}SHIFT,6,split-movetoworkspace,6
      bind = ${modifier}SHIFT,7,split-movetoworkspace,7
      bind = ${modifier}SHIFT,8,split-movetoworkspace,8
      bind = ${modifier}SHIFT,9,split-movetoworkspace,9
      bind = ${modifier}SHIFT,0,split-movetoworkspace,10
      bind = ${modifier}SUPERCTRL, right, split-changemonitor, next #Move active workspace to other monitor
      bind = ${modifier}SUPERCTRL, left, split-changemonitor, prev
      bind = ${modifier},mouse_down,workspace, e+1
      bind = ${modifier},mouse_up,workspace, e-1
      bindm = ${modifier},mouse:272,movewindow
      bindm = ${modifier},mouse:273,resizewindow
      bind = ALT,Tab,cyclenext
      bind = ALT,Tab,bringactivetotop
      
      #Volume Control
      bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = ,XF86AudioPlay, exec, playerctl play-pause
      bind = ,XF86AudioPause, exec, playerctl play-pause
      bind = ,XF86AudioNext, exec, playerctl next
      bind = ,XF86AudioPrev, exec, playerctl previous

      #Clipboard Shortcuts
      bind = SUPER, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy

      #Monitor Brightness
      bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
      bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%

      #Keyboard Brightness
      bind = ,XF86KbdBrightnessUp, exec, brightnessctl -d *::kbd_backlight set +20%
      bind = ,XF86KbdBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 20%-
    '' ];
  };
}
