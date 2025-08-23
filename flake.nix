{
  description = "Daniels-MacBook-Pro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/a683adc19ff5228af548c6539dbc3440509bfed3";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-stable-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    hyprland.url = "github:hyprwm/Hyprland";

    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Input for rust toolchain
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    bonofiglio-overlay = {
      url = "github:bonofiglio/nix-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmux-catppuccin = {
      url = "github:catppuccin/tmux";
      flake = false;
    };

    caelestia-shell.url = "github:caelestia-dots/shell";
    caelestia-shell.inputs.nixpkgs.follows = "nixpkgs";
    caelestia-cli.url = "github:caelestia-dots/cli";
    caelestia-cli.inputs.nixpkgs.follows = "nixpkgs";

    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      mkSystem = import ./lib/mkSystem.nix;
    in
    mkSystem "mbp-m1" "aarch64-darwin" inputs // mkSystem "asahi" "aarch64-linux" inputs;
}
