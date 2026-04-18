{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../users/daniel
    ../../users/daniel/jankyborders.nix
    ../../users/daniel/sketchybar
    ../../users/daniel/skhd.nix
    ../../users/daniel/yabai.nix
    ../../private
  ];

  home.stateVersion = "22.05";

  home.packages = with pkgs; [
    # UI apps
    moonlight-qt
    unar # Unarchiver
    vlc
    obsidian
    anki-bin

    # Holy grail
    raycast

    # Terminal tools
    podman
    unstable.colima
    docker
    docker-compose
    hyperfine
    m-cli
    ffmpeg
    rmtrash
    trash-cli
    gnugrep
    deploy-rs
    tmuxifier
    sops
    darwin-rebuild
  ];

  launchd.agents.raycast = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path ${pkgs.raycast} && exec open ${pkgs.raycast}/Applications/Raycast.app"
      ];
      ProcessType = "Interactive";
      KeepAlive = false;
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/raycast/raycast.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/raycast/raycast.err.log";
    };
  };
}
