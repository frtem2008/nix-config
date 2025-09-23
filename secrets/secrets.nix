let
  livefish = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6EAeX/7Vs4H+sTFHt+WTE5h5QI/nOBGierPWlb55RJ";
  livefish-lap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0yMfDsKed10Hf2gufUwyUOC9Vq5eimjorU1n6HTDAH";
  users = [ livefish livefish-lap ];

  livefish-nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGH912Mo7jPFG8jfL7oWuclmp+JrB6CysClxLDANmhMa";
  livefish-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0yMfDsKed10Hf2gufUwyUOC9Vq5eimjorU1n6HTDAH";
  systems = [ livefish-nix livefish-laptop ];


in
{
  "shadowsocks.age".publicKeys = users ++ systems;
  "wireguard-main.age".publicKeys = users ++ systems;
  "wireguard-synology.age".publicKeys = users ++ systems;
  "wireguard-itmo.age".publicKeys = users ++ systems;
}
