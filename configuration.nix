{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./grub.nix
      ./services.nix
      ./nvidia.nix
      ./hyprland/hyprland.nix
      ./wireguard/wireguard.nix
      ./shadowsocks/shadowsocks.nix
      ./sddm/sddm.nix
      ./jetbrains/jetbrains.nix
    ];

  services = {
    ntp.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    udisks2.enable = true;
#   dunst.enable = true;
  };
  security.polkit.enable = true;

  ### SOUND ###
  hardware.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem
  security.rtkit.enable = true; # Enable RealtimeKit for audio purposes

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Uncomment the following line if you want to use JACK applications
    # jack.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true; 
      };
    };
  };


  programs.amnezia-vpn.enable = true;

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

  networking.firewall.enable = false;
   
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
      ncdu
      cryptsetup
      home-manager
      lshw
      ntp
      wayland-utils # Wayland utilities
      vulkan-tools
      wl-clipboard # Command-line copy/paste utilities for Wayland
      wofi
      bat
      vlc
      qimgv # Image viewer

      gparted 
      polkit
      
      # Sound
      alsa-utils
      pavucontrol
      pamixer
      bluez
      bluez-tools

      btrfs-progs
      hyprpolkitagent

      amnezia-vpn

      hardinfo2
      
      inputs.agenix.packages."${system}".default
      inputs.sddm-stray.packages.${pkgs.system}.default
      inputs.prismlauncher-cracked.packages."${system}".default
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
