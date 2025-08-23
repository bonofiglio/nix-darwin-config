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
    battery
    moonlight-qt
    unar # Unarchiver
    vlc
    obsidian
    anki-bin
    feishin

    # Holy grail
    raycast

    # Terminal tools
    podman
    colima
    docker
    docker-compose
    nodePackages.pnpm
    nodePackages.yarn
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

    # Languages
    nodejs_22
    (fenix.latest.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rustc-codegen-cranelift-preview"
      "rust-analyzer"
    ])
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
