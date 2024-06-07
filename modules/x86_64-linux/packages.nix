{pkgs, ...}: {
  home.packages = with pkgs; [
    fuse-overlayfs
    glibcLocales
    grpc_cli
    netmask
    siege
    slirp4netns
  ];
}
