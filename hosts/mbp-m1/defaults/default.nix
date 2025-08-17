{ lib, ... }:
let
  inputSources = import ./input-sources.nix;
  dock = import ./dock.nix;
in
{
  # Menu bar
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  # Mouse
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false; # Whoose idea was to set this to true by default?

  # Dock
  system.defaults.dock.autohide = true;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.tilesize = 32;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.wvous-bl-corner = 1;
  system.defaults.dock.wvous-tl-corner = 1;
  system.defaults.dock.wvous-br-corner = 1;
  system.defaults.dock.wvous-tr-corner = 1;

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
  system.defaults.spaces.spans-displays = false;

  system.defaults.finder = {
    ShowExternalHardDrivesOnDesktop = true;
    ShowHardDrivesOnDesktop = true;
    ShowMountedServersOnDesktop = true;
    ShowRemovableMediaOnDesktop = true;
    _FXSortFoldersFirst = true;
    # When performing a search, search the current folder by default
    FXDefaultSearchScope = "SCcf";
  };

  system.defaults.CustomUserPreferences = {
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
      AppleInputSourceHistory = [ ];
      AppleSelectedInputSources = [ ];
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

  # Apply all defaults on activation
  system.activationScripts."set_defaults".text =
    lib.stringAfter
      [
        "users"
      ]
      lib.concatLines
      [
        inputSources
        dock
      ];
}
