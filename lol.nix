{ localFlake, withSystem }:
{ lib, config, ... }: {
  options = {
    services.foo = {
      package = lib.mkOption {
        default = withSystem ({ config, ... }: config.packages.default);
        defaultText = lib.literalMD "`packages.default` from the foo flake";
      };
    };
  };
}
