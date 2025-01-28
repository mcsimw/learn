{ flake-parts-lib, self, withSystem, ... }:
let
  inherit (flake-parts-lib) importApply;
in
{
  flake.nixosModules.default = importApply ./lol.nix { localFlake = self; inherit withSystem; };
}
