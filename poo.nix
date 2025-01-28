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
      _module.args.pkgs = import flake.self.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
