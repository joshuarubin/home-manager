{pkgs, ...}: {
  home.packages = with pkgs; [
    act
    alejandra
    aria
    bat
    buf
    cargo
    chezmoi
    clippy
    cmake
    colordiff
    colormake
    curl
    deadnix
    delta
    difftastic
    dig
    du-dust
    duf
    eternal-terminal
    exa
    fuse-overlayfs
    gcc
    gnumake
    grc
    htop
    infra
    jdk
    jq
    julia-bin
    k3s
    kubectl
    less
    lesspipe
    lua
    luajitPackages.luarocks
    luajitPackages.tl
    nodePackages.eslint
    nodePackages.prettier
    nodejs-16_x
    pass
    php
    php81Packages.composer
    pre-commit
    python310Full
    ran
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    safe-rm
    shellcheck
    shfmt
    slirp4netns
    sqlfluff
    statix
    stylua
    terraform
    tree-sitter
    unzip
    vale
    wget
    zsh-completions
  ];
}
