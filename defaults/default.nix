let
  inputSources = import ./input-sources.nix;
  dock = import ./dock.nix;
in
"${inputSources}\n${dock}"
