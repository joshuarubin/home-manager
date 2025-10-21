{
  sysConfig,
  outputs,
  genericLinux,
  lib,
  ...
}: {
  home = {
    inherit (sysConfig) username homeDirectory stateVersion;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "1password-cli"
          "amp-cli"
          "torch"
        ];
    };
  };

  news.display = "silent";

  targets.genericLinux.enable = genericLinux;
}
