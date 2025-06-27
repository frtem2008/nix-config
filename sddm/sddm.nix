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
      embeddedTheme = "hyprland_kath";
    })
  ];
}

#{
#  # Enable the KDE Plasma Desktop Environment.
#  services.displayManager.sddm = {
#    enable = true;
#    package = pkgs.lib.mkForce pkgs.libsForQt5.sddm;
#    extraPackages = pkgs.lib.mkForce [ 
#      pkgs.libsForQt5.qt5.qtgraphicaleffects
#    ];
#    
#    wayland.enable = true;
#
#    theme = "sddm-astronaut-theme";
#    settings = {
#      Theme = {
#        Current = "sddm-astronaut-theme";
#      };
#    };
#  };
#
#  environment.systemPackages = with pkgs; [
#    (sddm-astronaut.override {
#       embeddedTheme = "hyprland_kath";
#    })
#  ];
#}
#
#
