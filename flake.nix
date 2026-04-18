{
  description = "Daniels-MacBook-Pro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    hyprland.url = "github:hyprwm/Hyprland";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Input for rust toolchain
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    bonofiglio-overlay = {
      url = "github:bonofiglio/nix-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    tmux-catppuccin = {
      url = "github:catppuccin/tmux";
      flake = false;
    };

    caelestia-shell.url = "github:caelestia-dots/shell";
    caelestia-shell.inputs.nixpkgs.follows = "nixpkgs-unstable";
    caelestia-cli.url = "github:caelestia-dots/cli";
    caelestia-cli.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    inputs:
    let
      mkSystem = import ./lib/mkSystem.nix;
    in
    mkSystem "mbp-m1" "aarch64-darwin" inputs // mkSystem "asahi" "aarch64-linux" inputs;
}
