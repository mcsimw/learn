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
      _module.args.pkgs = import localFlake.self.inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    };
}
