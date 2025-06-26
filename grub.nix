{ config, lib, ... }:

{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    device = "nodev";
    gfxmodeEfi = "1600x900";
  };
}
