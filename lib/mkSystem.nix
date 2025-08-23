name: system: inputs:
let
  inherit (inputs.nixpkgs.lib) optionalAttrs attrValues;
  inherit (inputs.nixpkgs.legacyPackages.${system}.stdenv) isDarwin isLinux;

  stableNixpkgs = if isDarwin then inputs.nixpkgs-stable-darwin else inputs.nixpkgs-stable;

  hostConfig = ../hosts/${name};

  configName = if isDarwin then "darwinConfigurations" else "nixosConfigurations";
  builderFunction =
    if isDarwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
  home-manager =
    if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;

  custLib = {
    ifDarwinAttrs = optionalAttrs isDarwin;
    ifLinuxAttrs = optionalAttrs isLinux;
    toXml = import ./toXml.nix;
  };

  darwinOverlays = {
    # Overlay useful on Macs with Apple Silicon
    apple-silicon =
      final: prev:
      optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        # Add access to x86 packages system is running Apple Silicon
        pkgs-x86 = import inputs.nixpkgs {
          system = "x86_64-darwin";
          config.allowUnfree = true;
        };
      };
    custom-overlay = inputs.bonofiglio-overlay.overlays.default;
    nix-darwin = inputs.nix-darwin.overlays.default;
  };

  linuxOverlays = {
    caelestia = final: prev: {
      caelestia-shell = inputs.caelestia-shell.packages.${system}.with-cli;
      caelestia-cli = inputs.caelestia-cli.packages.${system}.default;
    };

    local = final: prev: {
      smc-lid = final.callPackage ../packages/smc-lid/pkg.nix { };
    };
  };

  overlays = {
    # Overlays to add various packages into package set
    comma = final: prev: {
      comma = import inputs.comma { inherit (prev) pkgs; };
    };

    stable = final: prev: {
      stable = import stableNixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

    tmux-custom-plugins = final: prev: {
      tmuxCustomPlugins = {
        catppuccin = prev.tmuxPlugins.mkTmuxPlugin {
          pluginName = "catppuccin";
          version = inputs.tmux-catppuccin.rev;
          src = inputs.tmux-catppuccin;
        };
      };
    };
    fenix = inputs.fenix.overlays.default;
  };
  specialArgs = {
    inherit inputs;
    inherit custLib;

    flakeRoot = import ../.flakeroot.nix;
  };
in
{
  ${configName}."${name}" = builderFunction {
    modules = [
      ../configuration.nix
      {
        nixpkgs.hostPlatform = system;
        nixpkgs.overlays = attrValues (
          overlays // custLib.ifDarwinAttrs darwinOverlays // custLib.ifLinuxAttrs linuxOverlays
        );
      }
      home-manager.home-manager
      {
        home-manager.extraSpecialArgs = specialArgs;
      }
      hostConfig
    ];
    inherit specialArgs;
  };
}
