{ pkgs, lib, ... }:
{
    # Nix configuration ------------------------------------------------------------------------------
    nix.settings.trusted-users = [
        "@admin"
    ];
    nix.configureBuildUsers = true;
    nixpkgs.hostPlatform = "aarch64-darwin";
    users.users.daniel.home = /Users/daniel;

    # Enable experimental nix command and flakes
    # nix.package = pkgs.nixUnstable;
    nix.extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
        '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
    '';

    # Create /etc/bashrc that loads the nix-darwin environment.
    programs.zsh.enable = true;

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;

    # System-wide apps
    environment.systemPackages = with pkgs; [];

    environment.pathsToLink = [ "/share/zsh" ];

    programs.nix-index.enable = true;

    # Fonts
    fonts.fontDir.enable = true;
    fonts.fonts = with pkgs; [
        (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    ];

    # Keyboard
    system.keyboard.enableKeyMapping = true;

    # Mouse
    system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false; # Whoose idea was to set this to true by default?

    # Dock
    system.defaults.dock.autohide = true;
    system.defaults.dock.show-recents = false;
    system.defaults.dock.tilesize = 32;
    system.defaults.dock.mru-spaces = false;

    # Finder
    system.defaults.finder.AppleShowAllExtensions = true;
    system.defaults.finder.AppleShowAllFiles = true;
    system.defaults.finder.QuitMenuItem = true;
    system.defaults.finder.ShowPathbar = true;
    system.defaults.finder.ShowStatusBar = true;
    system.defaults.finder._FXShowPosixPathInTitle = true;

    # Login
    system.defaults.loginwindow.GuestEnabled = false;

    # MacOS garbage
    system.defaults.spaces.spans-displays = true;

    system.defaults.CustomUserPreferences = {
        "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = true;
            ShowMountedServersOnDesktop = true;
            ShowRemovableMediaOnDesktop = true;
            _FXSortFoldersFirst = true;
            # When performing a search, search the current folder by default
            FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
        };
        "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
        };
        "com.apple.Spotlight" = {
            MenuItemHidden = true;
        };
        "com.apple.HIToolbox" = {
            AppleInputSourceHistory = [];
            AppleSelectedInputSources = [];
        };
        "com.raycast.macos" = {
            onboardingSkipped = 1;
            "onboarding_setupHotkey" = 1;
            "onboarding_showTasksProgress" = 1;
            raycastCurrentThemeId = "bundled-raycast-dark";
            raycastCurrentThemeIdDarkAppearance = "bundled-raycast-dark";
            raycastCurrentThemeIdLightAppearance = "bundled-raycast-light";
            raycastGlobalHotkey = "Command-36";
            raycastShouldFollowSystemAppearance = 1;
            showGettingStartedLink = 0;
            navigationCommandStyleIdentifierKey = "vim";
        };
    };
}
