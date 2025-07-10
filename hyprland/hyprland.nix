{ config, lib, pkgs, ... }:

{  
  programs.hyprland.enable = true; # enable Hyprland
  programs.hyprland.withUWSM  = true;
  
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [ 
    wofi

    hyprpaper 

    # Screen sharing
    xdg-desktop-portal-hyprland
    grim
    slurp
    hyprshot
  ];
}
