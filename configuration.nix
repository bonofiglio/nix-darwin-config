{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Nix configuration ------------------------------------------------------------------------------
  nix.enable = false;
  nix.settings.trusted-users = [
    "@admin"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.shells = [
    pkgs.bashInteractive
  ];

  nix.settings.substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
  # Use the same nixpkgs version always to avoid redownloding each time
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nix.extraOptions =
    ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    ''
    + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

  # Keyboard
  system.keyboard.enableKeyMapping = true;

  services.tailscale.enable = true;
}
