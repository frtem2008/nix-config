{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./grub.nix
      ./services.nix
      ./nvidia.nix
      ./hyprland.nix
    ];

  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    ntp.enable = true;
#    dunst.enable = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "livefish-nix"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

#  system.copySystemConfiguration = true;

  users.users.livefish = {
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager"];
      home = "/home/livefish";
      createHome = true;
  };
  
  # https://search.nixos.org/packages
  environment.systemPackages = with pkgs; [
      vim
      wget
      btop
      git
      firefox
      nix-prefetch-scripts
      which
      fastfetch
      hyprland
      far2l
      killall
      alacritty
      kitty
      wireguard-tools
      shadowsocks-rust
      gnome-disk-utility
      home-manager
      lshw
      wayland-utils # Wayland utilities
      ntp
      wl-clipboard # Command-line copy/paste utilities for Wayland
      wofi
      bat
#      dunst
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  
  # Never modify!
  system.stateVersion = "25.05";
}

