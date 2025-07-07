{ config, lib, pkgs, ... }:
let
  browser = [ "firefox.desktop" ];
  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/chrome" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
    "image/*" = [ "qimgv.desktop" ]; # */

    "audio/*" = [ "vlc.desktop" ]; # */
    "video/*" = [ "vlc.dekstop" ]; # */ 
    "application/json" = browser; # ".json"  JSON format
    "application/pdf" = browser; # ".pdf"  Adobe Portable Document Format (PDF)
  };
in rec
{
  # TODO please change the username & home directory to your own
  home.username = "livefish";
  home.homeDirectory = "/home/${home.username}";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    telegram-desktop

    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    libreoffice

    ggh # better ssh

    tldr

    obs-studio    
    yandex-music
    anydesk
    keepassxc
  ];
  
  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "livefish";
    userEmail = "ungazhiv2008@yandex.ru";
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = { 
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      font = {
				normal = {
					family = "JetBrains Mono Nerd Font";
					style = "Regular";
				};
				bold = {
					family = "JetBrains Mono Nerd Font";
					style = "Bold";
				};
				italic = {
					family = "JetBrains Mono Nerd Font";
					style = "Italic";
				};
				size = 11;
			};
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      fastfetch
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      ___MY_VMOPTIONS_SHELL_FILE="''${HOME}/.jetbrains.vmoptions.sh"; if [ -f "''${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "''${___MY_VMOPTIONS_SHELL_FILE}"; fi
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      ssh = "ggh";
      r = "sudo nixos-rebuild switch";
      rdb = "sudo nixos-rebuild switch --show-trace --print-build-logs --verbose";
      e = "sudo nano /etc/nixos/*"; /* for now */
#      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
#      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

    };
  };

  xdg.mimeApps.enable = lib.mkDefault true;
  xdg.configFile."mimeapps.list" = lib.mkIf config.xdg.mimeApps.enable { force = true; };
  xdg.mimeApps.associations.added = associations;
  xdg.mimeApps.defaultApplications = associations;

#  fonts.fontconfig.enable = true;
  # For hyprland 
  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  wayland.windowManager.hyprland.systemd.enable = false;  
#  home.file."${home.homeDirectory}/.config/hypr/hyprland.conf" = {
#    source = ./hyprland/hyprland.conf;
#  };
  
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
