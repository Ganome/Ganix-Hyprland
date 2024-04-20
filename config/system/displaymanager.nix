{ pkgs, config, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) theKBDVariant
theKBDLayout theSecondKBDLayout; in
{
  services.xserver = {
    enable = true;
    xkb = {
      variant = "${theKBDVariant}";
      layout = "${theKBDLayout}, ${theSecondKBDLayout}";
    };
    libinput.enable = true;
  };
  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
#      theme = "tokyo-night-sddm";
#      theme = "sddm-sugar-dark-theme";
#       theme = "sddm-zust";
      theme = "sddm-chili";
    };

  };

  environment.systemPackages =
let
    sugar = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix {};
    tokyo-night = pkgs.libsForQt5.callPackage ../pkgs/sddm-tokyo-night.nix {};
#    zust = pkgs.libsForQt5.callPackage ../pkgs/sddm-zust.nix{};  # Broken because of nested file structure - clone and rename subdir to sddm-zust to fix
    chili = pkgs.libsForQt5.callPackage ../pkgs/sddm-chili.nix{};
    ocean = pkgs.libsForQt5.callPackage ../pkgs/sddm-ocean.nix{};

in [ 
    sugar.sddm-sugar-dark # Name: sugar-dark
    tokyo-night # Name: tokyo-night-sddm
 #   zust #Name: sddm-zust
    chili # Name: sdd-chili
    ocean
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];
}
