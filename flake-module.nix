{
  flake-parts-lib,
  inputs,
  ...
}:
let
  inherit (flake-parts-lib) importApply;
in
{
  flake.nixosModules = {
    genesis = importApply ./genesis.nix {
      flake = inputs;
    };
    neogenesis = importApply ./neogenesis.nix {
      flake = inputs;
    };
  };
}
