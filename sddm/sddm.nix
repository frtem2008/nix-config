{ config, lib, pkgs, ... }:
{
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia
      kdePackages.qtsvg
      kdePackages.qtvirtualkeyboard
    ];
    theme = "sddm-astronaut-theme";
  };
  
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./sddm-astronaut-theme.nix {
      embeddedTheme = "pixel_sakura";
    })
  ];
}
