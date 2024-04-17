{ pkgs, config, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.default = "saved";
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.kernel.sysctl = { "vm.max_map_count" = 2147483642; };
  boot.tmp.useTmpfs = false;
  boot.tmp.tmpfsSize = "25%";

  # This is for OBS Virtual Cam Support - v4l2loopback setup
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
}
