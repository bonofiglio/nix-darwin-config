{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;

  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;

  ghosttyBin = if isDarwin then "/opt/homebrew/bin/ghostty" else lib.getExe pkgs.ghostty;

  validate =
    file: "${ghosttyBin} +validate-config --config-file=${config.xdg.configHome}/ghostty/${file}";
in
{
  programs.ghostty = {
    enable = !isDarwin;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      font-family = "JetBrainsMonoNL Nerd Font Mono";
      font-style = "semibold";
      font-size = 21;
      cursor-text = "#070707";
      background-opacity = 0.9;
      # See https://web.archive.org/web/20250109041625/https://invisible-island.net/xterm/modified-keys-gb-altgr-intl.html
      # For virtual key codes (7=55, 8=56)
      keybind = [
        "performable:ctrl+7=csi:27;5;55~"
        "performable:ctrl+8=csi:27;5;56~"
        "performable:ctrl+9=csi:27;5;57~"
        "performable:ctrl+0=csi:27;5;48~"
      ];
      command = "/bin/sh -c ${config.programs.nushell.package}/bin/nu";
    };
  };

  xdg.configFile = {
    "ghostty/config" = {
      source = keyValue.generate "ghostty-config" config.programs.ghostty.settings;
      onChange = validate "config";
    };
  };
}
