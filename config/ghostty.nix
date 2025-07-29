{
  pkgs,
  lib,
  config,
  ...
}:
let
  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;
  validate =
    file:
    "/opt/homebrew/bin/ghostty +validate-config --config-file=${config.xdg.configHome}/ghostty/${file}";
in
{
  programs.ghostty = {
    #
    enable = false;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      font-family = "JetBrainsMonoNL Nerd Font Mono";
      font-style = "semibold";
      font-size = 21;
      cursor-text = "#070707";
      # See https://web.archive.org/web/20250109041625/https://invisible-island.net/xterm/modified-keys-gb-altgr-intl.html
      # For virtual key codes (7=55, 8=56)
      keybind = [
        "performable:ctrl+7=csi:27;5;55~"
        "performable:ctrl+8=csi:27;5;56~"
        "performable:ctrl+9=csi:27;5;57~"
        "performable:ctrl+0=csi:27;5;48~"
      ];
      command = "${config.programs.nushell.package}/bin/nu";
    };
  };

  xdg.configFile = {
    "ghostty/config" = {
      source = keyValue.generate "ghostty-config" config.programs.ghostty.settings;
      onChange = validate "config";
    };
  };
}
