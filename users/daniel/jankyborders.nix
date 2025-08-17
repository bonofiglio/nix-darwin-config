{
  config,
  pkgs,
  lib,
  ...
}:
let
  agentName = "jankyborders";
  settings = {
    style = "round";
    width = 5.0;
    hidpi = "on";
    active_color = "'glow(0xff89b4fa)'";
    inactive_color = "0x00000000";
    ax_focus = false;
  };
in
{
  launchd.agents."${agentName}" = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path ${pkgs.jankyborders} && exec ${lib.getExe pkgs.jankyborders}"
      ];
      ProcessType = "Interactive";
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/jankyborders/jankyborders.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/jankyborders/jankyborders.err.log";
    };
  };

  xdg.configFile."borders/bordersrc" = {
    source = pkgs.writeShellScript "bordersrc" ''
      options=(
      ${lib.generators.toKeyValue { indent = "  "; } settings})

      ${lib.getExe pkgs.jankyborders} "''${options[@]}"
    '';
    onChange = ''
      /bin/launchctl bootout gui/$(id -u ${config.home.username}) ${config.home.homeDirectory}/Library/LaunchAgents/org.nix-community.home.${agentName}.plist
      /bin/launchctl bootstrap gui/$(id -u ${config.home.username}) ${config.home.homeDirectory}/Library/LaunchAgents/org.nix-community.home.${agentName}.plist
    '';
  };
}
