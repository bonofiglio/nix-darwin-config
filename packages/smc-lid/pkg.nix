{
  lib,
  fenix,
  makeRustPlatform,
}:
let
  rustPlatform = (
    makeRustPlatform {
      cargo = fenix.latest.cargo;
      rustc = fenix.latest.rustc;
    }
  );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smc-lid";
  version = "1.0.0";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
