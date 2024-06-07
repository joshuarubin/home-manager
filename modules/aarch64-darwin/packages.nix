{pkgs, ...}: {
  home.packages = with pkgs; [
    coreutils-prefixed
    pinentry_mac
  ];
}
