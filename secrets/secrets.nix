let
  livefish = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6EAeX/7Vs4H+sTFHt+WTE5h5QI/nOBGierPWlb55RJ";
  users = [ livefish ];

  livefish-nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGH912Mo7jPFG8jfL7oWuclmp+JrB6CysClxLDANmhMa";
  systems = [ livefish-nix ];
in
{
  "shadowsocks.age".publicKeys = [ livefish livefish-nix ];
  "wireguard-main.age".publicKeys = [ livefish livefish-nix ];
  "wireguard-synology.age".publicKeys = [ livefish livefish-nix ];
  "wireguard-itmo.age".publicKeys = [ livefish livefish-nix ];
}
