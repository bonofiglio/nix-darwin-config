{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./defaults
    ../../modules/darwin-shortcuts.nix
  ];

  nix.enable = lib.mkForce false;

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  environment.shells = [
    pkgs.zsh
    pkgs.nushell
  ];

  programs.zsh.enable = true;

  # environment.etc."sudoers.d/darwin-rebuild".source = pkgs.runCommand "sudoers-darwin-rebuild" { } ''
  #   DARWIN_REBUILD_BIN="${pkgs.darwin-rebuild}/bin/darwin-rebuild"
  #   SHASUM=$(sha256sum "$DARWIN_REBUILD_BIN" | cut -d' ' -f1)
  #   cat <<EOF >"$out"
  #   %admin ALL=(root) NOPASSWD: sha256:$SHASUM $DARWIN_REBUILD_BIN switch *
  #   EOF
  # '';
  #
  environment.etc."sudoers.d/yabai".source = pkgs.runCommand "sudoers-yabai" { } ''
    YABAI_BIN="${pkgs.yabai}/bin/yabai"
    SHASUM=$(sha256sum "$YABAI_BIN" | cut -d' ' -f1)
    cat <<EOF >"$out"
    %admin ALL=(root) NOPASSWD: sha256:$SHASUM $YABAI_BIN --load-sa
    EOF
  '';

  # Add lab nameservers from tailscale to be able to access domains defined in adguard such as
  # adguard.lab, homarr.lab, etc.
  environment.etc."resolver/lab".text = "nameserver 100.100.100.100";
  environment.etc."resolver/orbis".text = "nameserver 100.100.100.100";
  environment.etc."resolver/vega".text = "nameserver 100.100.100.100";

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    sketchybar-app-font
  ];

  system.primaryUser = "daniel";

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
    brews = [
      "ali"
      "mas"
      "showkey"
      "bitwarden-cli"
      "qemu"
      "cliproxyapi"
    ];
    casks = [
      "battery"
      "firefox"
      "slack"
      "linear-linear"
      "1password"
      "granola"
      "discord"
      "ngrok"
      "postman"
      "thunderbird"
      "qbittorrent"
      "ghostty"
      "visual-studio-code"
    ];
    masApps = {
      bitwarden = 1352778147;
    };
  };

  # Disable safe mode key for FireFox
  launchd.agents.disable-firefox-safe-mode-key = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/launchctl"
        "setenv"
        "MOZ_DISABLE_SAFE_MODE_KEY"
        "1"
      ];
      RunAtLoad = true;
      ServiceIPC = false;
    };
  };

  services.skhd.enable = false;

  # Keyboard
  system.keyboard.enableKeyMapping = true;

  users.users.daniel.home = "/Users/daniel";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.daniel = {
      home.homeDirectory = "/Users/daniel";
      imports = [ ./home.nix ];
    };
  };
}
