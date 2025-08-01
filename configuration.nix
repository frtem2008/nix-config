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
      ./docker/docker-compose.nix
    ];

  services = {
    ntp.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    udisks2.enable = true;
#   kmscon.enable = true;
#   dunst.enable = true;
  };
  security.polkit.enable = true;

  console.enable = true;
#  systemd.services."getty@tty1".enabled = true;

  ### SOUND ###
  services.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem
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
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  # For games, distributed via AppImage https://nixos.wiki/wiki/Steam
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "nouveau" ]; 

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "livefish-nix"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/01DA53C6EF18F070";
  };

#  system.copySystemConfiguration = true;

  users.users.livefish = {
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
      home = "/home/livefish";
      createHome = true;
  };

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      3003  # Immich ml
      51821 # Wireguard
    ];
  };
#
#  virtualisation.docker = {
#    enable = true;
#    enableNvidia = true;
#    rootless = {
#      enable = true;
#      setSocketVariable = true;
#      # Optionally customize rootless Docker daemon settings
#      daemon.settings = {
#        dns = [ "1.1.1.1" "8.8.8.8" ];
#      };
#    };
#  };
  hardware.nvidia-container-toolkit.enable = true;
   
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
      duf
      cryptsetup
      ntfs3g
      home-manager
      kmscon # KMS console instead of agetty
      lshw
      ntp
      wayland-utils # Wayland utilities
      vulkan-tools
      wl-clipboard # Command-line copy/paste utilities for Wayland
      wofi
      bat
      vlc
      qimgv # Image viewer

      sshfs
      ffmpeg

      xdg-terminal-exec
            
      gparted 
      polkit
      
      # Sound
      alsa-utils
      pavucontrol
      pamixer
      qpwgraph
      bluez
      bluez-tools

      btrfs-progs
      hyprpolkitagent

      amnezia-vpn

      # Epic games
      legendary-gl
      rare

      meld # Merge diffs
           
      hardinfo2

      undetected-chromedriver
      chromium

      font-awesome

      playerctl # for pause buttons on keyboard and handphones

      mlocate # locate and so on

      themechanger # GTK theme manager

      kdePackages.dolphin
      kdePackages.ark      
      kdePackages.qtsvg            # Dolphin svg icons support
      kdePackages.kio-fuse         # to mount remote filesystems via FUSE
      kdePackages.kio-extras       # extra protocols support (sftp, fish and more)
      kdePackages.plasma-workspace # File associations in dolphin open with window
      
      inputs.agenix.packages."${system}".default
      inputs.sddm-stray.packages.${pkgs.system}.default
      inputs.prismlauncher-cracked.packages."${system}".default
      inputs.compose2nix.packages.${system}.default
  ]; 

  nixpkgs.config.permittedInsecurePackages = [
    "fluffychat-linux-1.27.0"
    "olm-3.2.16"  
    "electron-34.5.8"
  ];
  
  fonts.enableDefaultPackages = true; # Basic unicode coverage
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
#  fonts.packages = with pkgs; [
#    # All nerd fonts
#    builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
#    noto-fonts
#    noto-fonts-cjk-sans
#    noto-fonts-emoji
#    liberation_ttf  
#   ];

  xdg.mime.enable = true;
  xdg.menus.enable = true;  

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
