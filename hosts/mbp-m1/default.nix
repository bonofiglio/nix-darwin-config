{
  config,
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

  users.users.daniel.home = /Users/daniel;

  # Set nushell as default shell
  environment.shells = [
    pkgs.zsh
    config.home-manager.users.daniel.programs.nushell.package
  ];
  users.users.daniel.shell = config.home-manager.users.daniel.programs.nushell.package;

  programs.zsh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.daniel = {
      imports = [ ./home.nix ];
    };
  };
}
