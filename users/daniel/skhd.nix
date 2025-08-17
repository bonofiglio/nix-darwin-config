{
  config,
  pkgs,
  lib,
  ...
}:
let
  yabai = "${pkgs.yabai}/bin/yabai";
in
{
  xdg.configFile."skhd/skhdrc" = {
    enable = true;
    executable = true;
    text = ''
      # alt + a / u / o / s are blocked due to umlaute

      # change space
      alt - 1 : ${yabai} -m space --focus 1
      alt - 2 : ${yabai} -m space --focus 2
      alt - 3 : ${yabai} -m space --focus 3
      alt - 4 : ${yabai} -m space --focus 4
      alt - 5 : ${yabai} -m space --focus 5
      alt - 6 : ${yabai} -m space --focus 6
      alt - 7 : ${yabai} -m space --focus 7
      alt - 8 : ${yabai} -m space --focus 8
      alt - 9 : ${yabai} -m space --focus 9

      # focus window
      alt - h : ${yabai} -m window --focus west
      alt - l : ${yabai} -m window --focus east
      alt - j : ${yabai} -m window --focus south
      alt - k : ${yabai} -m window --focus north

      # swap managed window
      shift + alt - h : ${yabai} -m window --swap west
      shift + alt - j : ${yabai} -m window --swap south
      shift + alt - k : ${yabai} -m window --swap north
      shift + alt - l : ${yabai} -m window --swap east

      # toggle floating
      alt - v : ${yabai} -m window --toggle float --grid 10:10:1:1:8:8

      # toggle full screen
      alt - f : ${yabai} -m window --toggle zoom-fullscreen

      # send window to space
      shift + alt - 1 : ${yabai} -m window --space 1
      shift + alt - 2 : ${yabai} -m window --space 2
      shift + alt - 3 : ${yabai} -m window --space 3
      shift + alt - 4 : ${yabai} -m window --space 4
      shift + alt - 5 : ${yabai} -m window --space 5
      shift + alt - 6 : ${yabai} -m window --space 6
      shift + alt - 7 : ${yabai} -m window --space 7
      shift + alt - 8 : ${yabai} -m window --space 8
      shift + alt - 9 : ${yabai} -m window --space 9
    '';
  };

  home.packages = [ pkgs.skhd ];

  # Use custom skhd agent because nix-darwin's module is unreliable at boot
  launchd.agents.skhd = {
    enable = true;
    config = {
      ProcessType = "Interactive";
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path ${pkgs.skhd} && exec ${lib.getExe pkgs.skhd} -c ${
          config.xdg.configFile."skhd/skhdrc".source
        }"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/skhd/skhd.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/skhd/skhd.err.log";
    };
  };
}
