{ pkgs, ... }:
{
  programs.quickshell = {
    enable = true;
    systemd.enable = false;
    activeConfig = null;
  };

  home.packages = with pkgs; [
    fish
    ddcutil
    brightnessctl
    app2unit
    cava
    networkmanager
    lm_sensors
    grim
    swappy
    wl-clipboard
    libqalculate
    inotify-tools
    bluez
    bash
    hyprland
    coreutils
    findutils
    file
  ];
}
