{
  config,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [
    ./quickshell
    ./waybar
    ../../../users/daniel
  ];

  home.stateVersion = "25.11";

  xdg.configFile."hypr" = {
    enable = true;
    source = config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/hosts/asahi/home/hypr";
    recursive = true;
  };

  xdg.configFile."caelestia" = {
    enable = true;
    source = config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/hosts/asahi/home/caelestia";
    recursive = true;
  };

  home.packages = with pkgs; [
    hellwal
    legcord
    ghostty
    xfce.thunar
    pavucontrol
  ];
}
