{pkgs, ...}: {
  home.packages = with pkgs; [
    colima
    coreutils-prefixed
    docker-client
    lima
    pngpaste
    pinentry_mac
  ];
}
