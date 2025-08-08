{
  description = "Daniels-MacBook-Pro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-stable-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

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
  };

  outputs =
    inputs:
    let
      mkSystem = import ./lib/mkSystem.nix;
    in
    mkSystem "mbp-m1" "aarch64-darwin" inputs;
}
