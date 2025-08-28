{
  pkgs,
  ...
}:
{
  imports = [
    ./defaults
    ../../modules/darwin-shortcuts.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  users.users.clanker = {
    name = "clanker";
    description = "AI agents user";
    createHome = true;
    isHidden = false;
    home = /Users/clanker;
    shell = pkgs.zsh;
    uid = 420;
  };
  users.knownUsers = [ "clanker" ];
  users.knownGroups = [ "clanker" ];

  users.groups.clanker = {
    name = "clanker";
    members = [ "clanker" ];
    gid = 420;
  };

  users.users.daniel = {
    home = /Users/daniel;
    shell = pkgs.zsh;
  };

  environment.shells = [
    pkgs.zsh
    pkgs.nushell
  ];

  programs.zsh.enable = true;

  environment.etc."sudoers.d/darwin-rebuild".source = pkgs.runCommand "sudoers-darwin-rebuild" { } ''
    DARWIN_REBUILD_BIN="${pkgs.darwin-rebuild}/bin/darwin-rebuild"
    SHASUM=$(sha256sum "$DARWIN_REBUILD_BIN" | cut -d' ' -f1)
    cat <<EOF >"$out"
    %admin ALL=(root) NOPASSWD: sha256:$SHASUM $DARWIN_REBUILD_BIN switch *
    EOF
  '';

  environment.etc."sudoers.d/yabai".source = pkgs.runCommand "sudoers-yabai" { } ''
    YABAI_BIN="${pkgs.yabai}/bin/yabai"
    SHASUM=$(sha256sum "$YABAI_BIN" | cut -d' ' -f1)
    cat <<EOF >"$out"
    %admin ALL=(root) NOPASSWD: sha256:$SHASUM $YABAI_BIN --load-sa
    EOF
  '';

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
    brews = [
      "ali"
      "rom-tools"
      "mas"
      "showkey"
      "stripe-cli"
      "bitwarden-cli"
    ];
    casks = [
      "firefox"
      "slack"
      "linear-linear"
      "1password"
      "granola"
      "craft"
      "discord"
      "handbrake-app"
      "ngrok"
      "postman"
      "microsoft-teams"
      "thunderbird"
      "qbittorrent"
      "ghostty"
      "utm"
      "visual-studio-code"
      "zed"
      {
        name = "librewolf";
        args = {
          no_quarantine = true;
        };
      }
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.daniel = {
      imports = [ ./home.nix ];
    };
  };
}
