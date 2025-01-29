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
  isoModules = [
    { imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-base.nix" ]; }
    { boot.initrd.systemd.enable = lib.mkForce false; }
    { isoImage.squashfsCompression = "lz4"; }
    { networking.wireless.enable = lib.mkForce false; }
  ];
  nonIsoModules = [ inputs.nixpkgs.nixosModules.readOnlyPkgs ];
  configForSub = { sub, iso ? false }:
    let sys = withSystem sub.system;
    in sys (_:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = sys ({ inputs', self', ... }: { inherit self' inputs' inputs; });
        modules = [
          { networking.hostName = sub.hostname; }
          { nixpkgs.pkgs = sys ({ pkgs, ... }: pkgs); }
          sub.src
        ] ++ (if iso then isoModules else nonIsoModules);
      }
    );
in
{
  options.genesis.compootuers = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        hostname = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
        src = lib.mkOption { type = lib.types.path; default = null; };
        system = lib.mkOption { type = lib.types.str; default = null; };
      };
    });
    default = [ ];
  };
  config = {
    flake.nixosConfigurations = builtins.foldl' (acc: sub:
      if sub.hostname == null then acc else
      acc // {
        ${sub.hostname} = configForSub { inherit sub; iso = false; };
        "${sub.hostname}-iso" = configForSub { inherit sub; iso = true; };
      }
    ) {} config.genesis.compootuers;
  };
}
