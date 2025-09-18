{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking.wireguard.enable = true;

  age.secrets = {
    wireguard-main = {
      file = ../secrets/wireguard-main.age;
      # path = "/etc/nixos/wireguard/client_private.key";
      owner = "root";
      group = "root";
      mode = "600";
    };

    wireguard-synology = {
      file = ../secrets/wireguard-synology.age;
      # path = "/etc/nixos/wireguard/syn_client_private.key";
      owner = "root";
      group = "root";
      mode = "600";
    };

    wireguard-itmo = {
      file = ../secrets/wireguard-itmo.age;
      # path = "/etc/nixos/wireguard/itmo_private.key";
      owner = "root";
      group = "root";
      mode = "600";
    };
  };

  networking.wg-quick.interfaces = {
    wg-finka = {
      autostart = false;

      # IP address of this machine in the *tunnel network*
      address = [ "10.10.10.3/32" ];
      # Path to the private key file.
      # privateKeyFile = "/etc/nixos/wireguard/client_private.key";
      privateKeyFile = config.age.secrets.wireguard-main.path;
      mtu = 1300;
      peers = [{
        publicKey = "y1IyAi61re9vucTKWFOY1qsWVmCCvDs2iXL1qNbsBDo=";
        allowedIPs = [ "0.0.0.0/0" "::/0"];
        endpoint = "127.0.0.1:1080";
        persistentKeepalive = 25;
      }];
    };

    wg-oxff = {
      # IP address of this machine in the *tunnel network*
      address = [ "10.0.0.2/24" ];

      # Path to the private key file.
      privateKeyFile = config.age.secrets.wireguard-main.path;
      listenPort = 51821;
      peers = [{
        publicKey = "47el/BtTAmXHRHbkCHcOotZUL71ywxDgDL5PBgobD0w=";
        allowedIPs = [ "10.0.0.0/24" ];
        endpoint = "93.100.76.237:51820";
        persistentKeepalive = 25;
      }];
    };

    wg-syn = {
      # IP address of this machine in the *tunnel network*
      address = [ "100.81.3.134/32" ];

      # Path to the private key file.
      privateKeyFile = config.age.secrets.wireguard-synology.path;

      peers = [{
        publicKey = "xhTbdj00i3kmY5zVQNDxdsh9Qs6AanV2MKpy7IX/ZU4=";
        presharedKey = "efS9MkQZQaFvo74KMe9jp2na5M1i0Nxc0GWg7FfS0XY=";
        allowedIPs = [ "10.78.1.3/32" ];
        endpoint = "91.122.49.229:42145";
        persistentKeepalive = 25;
      }];
    };

    wg-itmo = {
      address = [ "10.10.19.207/32" ];
      mtu = 1420;
      dns = ["10.10.187.33" "10.10.10.10" "8.8.8.8"];
      privateKeyFile = config.age.secrets.wireguard-itmo.path;
      peers = [{
        publicKey = "Vx/1d/96BrruXtFz2REdxmHWahpWSHjUH8sUgT5uZDs=";
        allowedIPs = [ "10.10.16.1/32" "10.10.10.0/24" "10.10.187.0/24"];
        endpoint = "vpn.itmo.xyz:51820";
        persistentKeepalive = 25;
      }];
    };
  };
}
