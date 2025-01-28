{ pkgs, flake, localFlake, ... }:
{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      inputs',
      ...
    }:
    {
      _module.args.pkgs = import flake.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
