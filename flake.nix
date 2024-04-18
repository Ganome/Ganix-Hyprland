{
  description = "GanomeOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    hyprland.url = "github:hyprwm/Hyprland";
    
    # Split Monitor Workspaces plugin
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    # hyprland base plugin repo - hyprtrails, hyprbars, etc...
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs@{ nixpkgs, home-manager, impermanence, split-monitor-workspaces, ... }:
  let 
    system = "x86_64-linux";
    inherit (import ./hosts/${host}/options.nix) username hostname;
    host = "ganix";

    pkgs = import nixpkgs {
      inherit system;
      config = {
	    allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      "${hostname}" = nixpkgs.lib.nixosSystem {
	specialArgs = { 
          inherit system; inherit inputs; 
          inherit username; inherit hostname;
          inherit host;
        };
        modules = [ 
#BEGIN-SPLIT-MONITOR
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ganome = {
                wayland.windowManager.hyprland = {
                  # ...
                  plugins = [
                    split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
                  ];
                  # ...
                };
              };
            };
          }

          ./system.nix
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = {
              inherit username; inherit inputs;
              inherit host;
              inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./users/default/home.nix;
          }
        ]; 
      


      };
    };
  };
}
