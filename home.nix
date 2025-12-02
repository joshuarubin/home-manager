{
  sysConfig,
  outputs,
  genericLinux,
  lib,
  nur,
  allowedUnfreePackages,
  ...
}: {
  home = {
    inherit (sysConfig) username homeDirectory stateVersion;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      nur.overlays.default
    ];

    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) allowedUnfreePackages;
    };
  };

  news.display = "silent";

  targets.genericLinux.enable = genericLinux;
}
