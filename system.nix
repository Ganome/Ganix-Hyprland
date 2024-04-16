{ inputs, config, pkgs,
  username, hostname, host, ... }:

let 
  inherit (import ./hosts/${host}/options.nix) 
    theLocale theTimezone gitUsername
    theShell wallpaperDir wallpaperGit
    theLCVariables theKBDLayout flakeDir
    theme;
in {
  imports =
    [
      ./hosts/${host}/hardware.nix
      ./config/system
      ./users/users.nix
    ];

  # Enable networking
  networking.hostName = "${hostname}"; # Define your hostname
  networking.domain = "ganomehome.com";
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "${theTimezone}";

  # Select internationalisation properties
  i18n.defaultLocale = "${theLocale}";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${theLCVariables}";
    LC_IDENTIFICATION = "${theLCVariables}";
    LC_MEASUREMENT = "${theLCVariables}";
    LC_MONETARY = "${theLCVariables}";
    LC_NAME = "${theLCVariables}";
    LC_NUMERIC = "${theLCVariables}";
    LC_PAPER = "${theLCVariables}";
    LC_TELEPHONE = "${theLCVariables}";
    LC_TIME = "${theLCVariables}";
  };

  console.keyMap = "${theKBDLayout}";

  # Define a user account.
  users = {
    mutableUsers = true;
  };

  environment.variables = {
    FLAKE = "${flakeDir}";
    ZANEYOS_VERSION="1.0";
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # /etc/hosts File
  networking.extraHosts =
    ''
    192.168.0.17  ganix.ganomehome.com    ganix
    192.168.0.16  truenas.ganomehome.com  truenas
    192.168.0.100 beefypi.ganomehome.com  beefypi
    192.168.0.123 irc.ganomehome.com      irc
    192.168.0.64  gentop.ganomehome.com   gentop
    '';


  system.stateVersion = "23.11";
}
