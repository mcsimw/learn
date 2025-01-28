{ pkgs, localFlake, ... }:
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
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
