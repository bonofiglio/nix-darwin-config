{ pkgs, inputs, ... }:
{
  # Desktop
  services.displayManager.gdm.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.enableHidpi = true;
  services.xserver = {
    enable = true;

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Hyprland pog
  programs.hyprland = {
    enable = true;
    withUWSM = false;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
