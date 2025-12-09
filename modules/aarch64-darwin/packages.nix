{
  pkgs,
  unstable,
  ...
}: {
  home.packages = with pkgs; [
    colima
    coreutils-prefixed
    unstable.docker-client
    lima
    pngpaste
    pinentry_mac
  ];
}
