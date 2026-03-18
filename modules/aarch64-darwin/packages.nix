{
  pkgs,
  unstable,
  ...
}: {
  home.packages = with pkgs; [
    unstable.colima
    coreutils-prefixed
    unstable.docker-client
    unstable.lima
    pngpaste
    pinentry_mac
  ];
}
