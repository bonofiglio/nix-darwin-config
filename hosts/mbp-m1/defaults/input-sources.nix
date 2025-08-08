{ custLib, ... }:
let
  inherit (custLib) toXml;
in
''
  defaults write com.apple.HIToolbox AppleEnabledInputSources "${
    toXml [
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
    ]
  }"
''
