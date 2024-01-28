let
  toXml = import ../lib/to-xml.nix;
in
''
  defaults write com.apple.HIToolbox AppleEnabledInputSources "${toXml [
      {
              InputSourceKind = "Keyboard Layout";
              "KeyboardLayout ID" = 252;
              "KeyboardLayout Name" = "ABC";
      }
      {
          InputSourceKind = "Keyboard Layout";
          "KeyboardLayout ID" = 87;
          "KeyboardLayout Name" = "Spanish - ISO";
      }
  ]}"

  defaults write com.apple.dock persistent-apps "${toXml [
          {
              "tile-data" = {
                  "bundle-identifier" = "com.apple.Safari";
                  "file-data" = {
                      "_CFURLString" = "file:///System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/";
                      "_CFURLStringType" = 15;
                  };
                  "file-label" = "Safari";
                  "file-type" = 41;
              };
              "tile-type" = "file-tile";
          }
          {
              "tile-data" = {
                  "bundle-identifier" = "org.mozilla.firefox";
                  "file-data" =                 {
                      "_CFURLString" = "file://$(realpath \"$HOME/Applications/Home Manager Apps/Firefox.app/\")";
                      "_CFURLStringType" = 15;
                  };
                  "file-type" = 41;
                  "file-label" = "Firefox";
              };
              "tile-type" = "file-tile";
          }
          {
              "tile-data" =             {
                  "bundle-identifier" = "com.apple.mail";
                  "file-data" =                 {
                      "_CFURLString" = "file:///System/Applications/Mail.app/";
                      "_CFURLStringType" = 15;
                  };
                  "file-label" = "Mail";
                  "file-type" = 41;
              };
              "tile-type" = "file-tile";
          }
          {
              "tile-data" = {
                  "bundle-identifier" = "com.raycast.macos";
                  "file-data" =                 {
                      "_CFURLString" = "file://$(realpath \"$HOME/Applications/Home Manager Apps/Raycast.app/\")";
                      "_CFURLStringType" = 15;
                  };
                  "file-label" = "Raycast";
                  "file-type" = 41;
              };
              "tile-type" = "file-tile";
          }
          {
              "tile-data" =             {
                  "bundle-identifier" = "com.apple.iCal";
                  "file-data" =                 {
                      "_CFURLString" = "file:///System/Applications/Calendar.app/";
                      "_CFURLStringType" = 15;
                  };
                  "file-label" = "Calendar";
                  "file-type" = 41;
              };
              "tile-type" = "file-tile";
          }
          {
              "tile-data" =             {
                  "bundle-identifier" = "com.apple.AppStore";
                  "file-data" =                 {
                      "_CFURLString" = "file:///System/Applications/App%20Store.app/";
                      "_CFURLStringType" = 15;
                  };
                  "file-label" = "App Store";
                  "file-type" = 41;
              };
              "tile-type" = "file-tile";
          }
          {
              "tile-data" =             {
                  "bundle-identifier" = "com.apple.systempreferences";
                  "file-data" =                 {
                      "_CFURLString" = "file:///System/Applications/System%20Settings.app/";
                      "_CFURLStringType" = 15;
                  };
                  "file-label" = "System Settings";
                  "file-type" = 41;
              };
              "tile-type" = "file-tile";
          }
      ]
  }"

  defaults write com.apple.dock persistent-others "<array></array>"

  killall Dock
''
