{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar
    ../../../users/daniel
  ];

  home.stateVersion = "25.11";

  home.packages = with pkgs; [ hellwal ];
}
