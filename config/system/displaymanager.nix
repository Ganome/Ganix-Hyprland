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
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
#      theme = "tokyo-night-sddm";
#      theme = "sddm-sugar-dark-theme";
       theme = "sddm-zust";
    };
  };

  environment.systemPackages =
let
    sugar = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix {};
    tokyo-night = pkgs.libsForQt5.callPackage ../pkgs/sddm-tokyo-night.nix {};
    zust = pkgs.libsForQt5.callPackage ../pkgs/sddm-zust.nix{}; #broken
in [ 
    sugar.sddm-sugar-dark # Name: sugar-dark
    tokyo-night # Name: tokyo-night-sddm
    zust #Name: sddm-zust
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];
}
