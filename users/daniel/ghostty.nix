{
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  programs.ghostty = {
    enable = true;
    package = if isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    enableZshIntegration = true;
    settings = {
      theme = "TokyoNight Storm";
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
    };
  };
}
