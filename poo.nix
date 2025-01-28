localFlake:
{
  lib,
  config,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      inputs',
      ...
    }:
    {
      _module.args.pkgs = import localFlake.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    };
}
