{
  sysConfig,
  outputs,
  genericLinux,
  ...
}: {
  home = {
    inherit (sysConfig) username homeDirectory stateVersion;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];

    config = {
      allowUnfree = true;
    };
  };

  targets.genericLinux.enable = genericLinux;
}
