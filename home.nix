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

    # config = {
    #   allowUnfree = true;
    # };
  };

  news.display = "silent";

  targets.genericLinux.enable = genericLinux;
}
