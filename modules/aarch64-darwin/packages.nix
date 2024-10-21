{pkgs, ...}: {
  home.packages = with pkgs; [
    colima
    coreutils-prefixed
    docker-client
    lima-bin
    pngpaste
    pinentry_mac
  ];
}
