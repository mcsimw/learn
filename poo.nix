{ localFlake, withSystem, ... }:
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
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      config = {
        nixpkgs.pkgs = withSystem system ({pkgs, ...}: pkgs)
      };
    };
}
