{ config, lib, ... }:
let
  cfg = config.programs.sketchybar;
in
{
  programs.sketchybar = {
    enable = true;
    config = {
      # TODO: replace with flake path
      source = config.lib.file.mkOutOfStoreSymlink "/Users/daniel/.config/nix-darwin-config/users/daniel/sketchybar/config";
      recursive = true;
    };
    configType = "lua";
  };

  launchd.agents.sketchybar.config.Program = lib.mkOverride 10 null;
  launchd.agents.sketchybar.config.ProgramArguments = lib.mkOverride 10 [
    "/bin/sh"
    "-c"
    "/bin/wait4path ${cfg.finalPackage} && exec ${lib.getExe cfg.finalPackage}"
  ];
}
