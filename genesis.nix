{ flake, ... }:
{
  config,
  lib,
  inputs,
  withSystem,
  ...
}:
let
  modulesPath = "${inputs.nixpkgs.outPath}/nixos/modules";
  configForSub =
    {
      sub,
      iso ? false,
    }:
    let
      baseModules = [
        {
          networking.hostName = sub.hostname;
          nixpkgs.pkgs = withSystem sub.system ({ pkgs, ... }: pkgs);
        }
        sub.src
        #        flake.self.nixosModules.default
        #        flake.self.nixosModules.fakeFileSystems
      ];
      isoModules = [
        {
          imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-base.nix" ];
          boot.initrd.systemd.enable = lib.mkForce false;
          isoImage.squashfsCompression = "lz4";
          networking.wireless.enable = lib.mkForce false;
        }
      ];
      nonIsoModules = [
        inputs.nixpkgs.nixosModules.readOnlyPkgs
      ];
    in
    withSystem sub.system (
      _:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = withSystem sub.system (
          { inputs', self', ... }:
          {
            inherit self' inputs' inputs;
          }
        );
        modules = baseModules ++ lib.optionals iso isoModules ++ lib.optionals (!iso) nonIsoModules;
      }
    );
in
{
  options.genesis = {
    compootuers = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            hostname = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            src = lib.mkOption {
              type = lib.types.path;
              default = null;
            };
            system = lib.mkOption {
              type = lib.types.str;
              default = null;
            };
          };
        }
      );
      default = [ ];
    };
  };
  config = {
    flake.nixosConfigurations = builtins.listToAttrs (
      lib.concatMap (
        sub:
        if sub.hostname == null then
          [ ]
        else
          [
            {
              name = sub.hostname;
              value = configForSub {
                inherit sub;
                iso = false;
              };
            }
            {
              name = "${sub.hostname}-iso";
              value = configForSub {
                inherit sub;
                iso = true;
              };
            }
          ]
      ) config.genesis.compootuers
    );
    perSystem =
      {
        pkgs,
        system,
        ...
      }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = with flake; [
            nix.overlays.default
            emacs-overlay.overlays.default
          ];
        };
      };
  };
  imports = [
    flake.treefmt-nix.flakeModule
  ];
}
