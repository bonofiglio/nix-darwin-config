{ pkgs, inputs, ... }:
{
  # Desktop
  services.displayManager.gdm.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.enableHidpi = true;
  services.xserver = {
    enable = true;

    xkb = {
      layout = "us,es";
      variant = "";
    };
  };

  # Hyprland pog
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprshot
    caelestia-shell
    caelestia-cli

    (fenix.latest.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rustc-codegen-cranelift-preview"
      "rust-analyzer"
    ])
  ];

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
