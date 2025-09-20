{ config, lib, pkgs, ... }:

{
  # programs.waybar.enable = true;

  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  #environment.systemPackages = with pkgs; [
  home.packages = with pkgs; [ 
    hyprpaper

    # Screen sharing
    xdg-desktop-portal-hyprland
    grim
    slurp
    hyprshot

    waybar
    clipse

    hyprlock
    hypridle

    rofi
    rofi-calc
    rofi-emoji
    rofi-mpd
    rofi-vpn
    rofi-systemd
    rofi-bluetooth
    rofi-power-menu
    rofi-network-manager

    keepmenu
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
         "/home/livefish/nixos-config/hyprland/wallpapers/Fantasy-Japanese-Street.png" 
         "/home/livefish/nixos-config/hyprland/wallpapers/illustration-anime-city.jpg"
      ];
      wallpaper = [
        "HDMI-A-1, /home/livefish/nixos-config/hyprland/wallpapers/illustration-anime-city.jpg" 
        "DP-1,     /home/livefish/nixos-config/hyprland/wallpapers/Fantasy-Japanese-Street.png"
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
          lock_cmd = "/home/livefish/nixos-config/hyprland/scripts/lock.sh";
          before_sleep_cmd = "/home/livefish/nixos-config/hyprland/scripts/lock.sh";     # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on";                                  # to avoid having to press a key twice to turn on the display.
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
      };
                   
      listener = [
        {
            timeout = 300;                                                          # 5min
            on-timeout = "/home/livefish/nixos-config/hyprland/scripts/lock.sh";       # lock screen when timeout has passed
        }
        {
          timeout = 330;                                                     # 5.5min
          on-timeout = "hyprctl dispatch dpms off";                            # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";          # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 1200;                                # 20min
          on-timeout = "systemctl suspend";                # suspend pc
        }
      ]; 
    };
  };
}
