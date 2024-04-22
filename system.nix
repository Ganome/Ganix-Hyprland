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

  #Enable SSH Authorized Keys
  users.users.${username}.openssh.authorizedKeys = {
 #   keyFiles =[
 #   /home/${username}/.ssh/authorized_keys
 # ];
  keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVHrhdDdSTpdbJidW0t6ShSM/pYctFUKViLsqgsTR6XHpETiCPOA5zrGkWnw1FPlHOZMiKrw88DjqIaeF5LlBV4NxBo6qAn72wJHvNkKKdAW3MeXpt26x2KAYXUtg4vAJHQ6SsG8To6EaksZGyIUpbTkVRcVUU726OxregVFTSgiZT22T3Xm/uIFTv4SxZv2Jm4ShUn48Pc1RSPTkbe9xEdCu7vOLdBLmeTPW9kN+/gR9lbuOg5YGXwRisKcDrkPCRpmlMYd9DdMvmMW1LM1dpuGYfSe85epon1J+4wuCxab3pxuCMmKzA06XuYvVCQxZyFh/KN1ZLpjaGIld0DIK8cwzhfhsbEmFCxm/GOH7EER2iof/VhDYmqYPCDq8frqT3PSjBawp+1B9/FDE49JeTFq8YNiQZr5kv2zMHkQ8LT5m1JPVPS66YHDcCsvjmh3OB8vpIpA4X+F+yRZWKkBdE0tviqhj04p2IyZN5sKSsDryikur9M98MFgCzrcNBo/JabKlIu3K5DOEWe91sFbi3GbBFsIYgILSyNQK0AD3zTCSfcgbCQ66g+k1xDPKR9lq972kir/fwPmUipTQpc4MJbeHCtcoIBeO60eMFS2GIDAacRSj5ul2IwQmK10XZNY2C/v93JoDJLh0SVK6XOdTTmtJqVwVPdBbQtS/fruJojw== Ganome's RSA Key"
  ];
};
  # Enable networking
  networking.hostName = "${hostname}"; # Define your hostname
  #networking.hostName = "nixtop";  # This line so that laptop will build with a different hostname
  networking.domain = "ganomehome.com";
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "${theTimezone}";

  # Enable Docker
  virtualisation.docker.enable = true;

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
    192.168.0.64  nixtop.ganomehome.com   nixtop
    '';

  system.stateVersion = "23.11";
}
