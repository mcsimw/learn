{
  flake-parts-lib,
  self,
  withSystem,
  inputs,
  ...
}:
let
  inherit (flake-parts-lib) importApply;
in
{
  flake.nixosModules.default = importApply ./lol.nix {
    localFlake = self;
    inherit withSystem;
  };
  flake.nixosModules.genesis = importApply ./genesis.nix {
    localFlake = self;
    inherit withSystem;
    flake = inputs;
  };
  flake.nixosModules.poo = ./poo.nix;
}
