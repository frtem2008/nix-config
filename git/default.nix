{ config, lib, pkgs, ... }:

let
  # put a shell script into the nix store
  gitIdentity =
    pkgs.writeShellScriptBin "git-identity" (builtins.readFile ./git-identity);
in {
  # we will use the excellent fzf in our `git-identity` script, so let's make sure it's available
  # let's add the gitIdentity script to the path as well
  home.packages = with pkgs; [
    gitIdentity
    fzf
  ];

  programs.git = {
    enable = true;
    extraConfig = {
      # extremely important, otherwise git will attempt to guess a default user identity. see `man git-config` for more details
      user.useConfigOnly = true;

      # the `work` identity
      user.work.name = "livefish";
      user.work.email = "livefish@unprism.ru";

      # the `personal` identity
      user.personal.name = "livefish";
      user.personal.email = "ungazhiv2008@yandex.ru";
      # I think spider-man might be peter parker! somebody get j jonah jameson on the line
    };
    # This is optional, as `git identity` will call the `git-identity` script by itself, however
    # setting it up explicitly as an alias gives you autocomplete
    aliases = {
      identity = "! git-identity";
      id = "! git-identity";
    };
  };

}
