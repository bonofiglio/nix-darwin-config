{
  config,
  lib,
  darwinConfig,
  ...
}:
let
  cfg = config.programs.sketchybar;
in
{
  programs.sketchybar = {
    enable = true;
    config = {
      source = ./config;
      recursive = true;
    };
    configType = "lua";
  };

  launchd.agents.sketchybar.config.EnvironmentVariables = {
    PATH = "${darwinConfig.environment.systemPath}:${config.home.homeDirectory}/.nix-profile/bin:/etc/profiles/per-user/${config.home.username}/bin";
  };
  launchd.agents.sketchybar.config.Program = lib.mkOverride 10 null;
  launchd.agents.sketchybar.config.ProgramArguments = lib.mkOverride 10 [
    "/bin/sh"
    "-c"
    "/bin/wait4path ${cfg.finalPackage} && exec ${lib.getExe cfg.finalPackage}"
  ];
}
