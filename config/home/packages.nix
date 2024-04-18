{ pkgs, config, username, host, ... }:

let 
  inherit (import ../../hosts/${host}/options.nix) 
    browser wallpaperDir wallpaperGit flakeDir;
in {
  # Install Packages For The User
  home.packages = with pkgs; [
    pkgs."${browser}" webcord-vencord libvirt swww grim grimblast slurp gnome.file-roller
    swaynotificationcenter rofi-wayland imv transmission-gtk mpv
    gimp rustup audacity pavucontrol tree protonup-qt
    spotify swayidle neovide swaylock quasselClient helvum tldr
    asciiquarium-transparent cmatrix geany cliphist font-awesome
    dtach sxiv lsof wofi fortune mangohud cpu-x fuse amf-headers
    mpd mpc-cli mpc-qt cifs-utils
    (pkgs.wrapOBS { plugins = [ pkgs.obs-studio-plugins.obs-vaapi pkgs.obs-studio-plugins.obs-vkcapture ]; })
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # Import Scripts
    (import ./../scripts/emopicker9000.nix { inherit pkgs; })
    (import ./../scripts/task-waybar.nix { inherit pkgs; })
    (import ./../scripts/squirtle.nix { inherit pkgs; })
    (import ./../scripts/wallsetter.nix { inherit pkgs; inherit wallpaperDir;
      inherit username; inherit wallpaperGit; })
    (import ./../scripts/themechange.nix { inherit pkgs; inherit flakeDir; inherit host; })
    (import ./../scripts/theme-selector.nix { inherit pkgs; })
    (import ./../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ./../scripts/web-search.nix { inherit pkgs; })
    (import ./../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ./../scripts/screenshootin.nix { inherit pkgs; })
    (import ./../scripts/list-hypr-bindings.nix { inherit pkgs; inherit host; })
  ];

  programs.gh.enable = true;
}
