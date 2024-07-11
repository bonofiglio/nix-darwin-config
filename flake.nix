{
  description = "Daniels-MacBook-Pro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";

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

    bonofiglio-nixvim.url = "github:bonofiglio/nixvim-config";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-stable, darwin, home-manager, fenix, bonofiglio-overlay, bonofiglio-nixvim }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;
      system = "aarch64-darwin";

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == system) {
            inherit (final.pkgs-x86)
              idris2
              nix-index
              niv
              purescript;
          })
        );
      };
    in
    {
      darwinConfigurations."Daniels-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            home-manager =
              {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.daniel = {
                  imports = [ ./home.nix ];
                };
              };
          }
          ./shortcuts.nix
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      overlays = {
        # Overlays to add various packages into package set
        comma = final: prev: {
          comma = import inputs.comma { inherit (prev) pkgs; };
        };

        stable = final: prev: {
          stable = import nixpkgs-stable
            {
              inherit system;
              config.allowUnfree = true;
            };
        };

        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == system) {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };
        fenix = inputs.fenix.overlays.default;
        custom-overlay = bonofiglio-overlay.overlays.default;
        bonofiglio-nixvim = final: prev: {
          bonofiglio-nixvim = bonofiglio-nixvim.outputs.packages."${prev.stdenv.system}".default;
        };
      };
    };
}


