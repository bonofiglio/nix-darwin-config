{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
  ];
  home.stateVersion = "25.11";
}
