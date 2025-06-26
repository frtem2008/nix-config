{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./grub.nix
      ./services.nix
      ./nvidia.nix
      ./hyprland.nix
      ./wireguard/wireguard.nix
      ./shadowsocks/shadowsocks.nix
    ];

  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    ntp.enable = true;
    openssh.enable = true;
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
      gnome-disk-utility
      home-manager
      lshw
      ntp
      wayland-utils # Wayland utilities
      wl-clipboard # Command-line copy/paste utilities for Wayland
      wofi
      bat
      inputs.agenix.packages."${system}".default
  ];

  programs.nano.nanorc = ''
      set tabstospaces
      set tabsize 2
      set autoindent
      set indicator
      set multibuffer
      set magic # May consume time
      set positionlog
      set linenumbers
    '';

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  
  # Never modify!
  system.stateVersion = "25.05";
}

