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
    cpplint
    curl
    deadnix
    delta
    deno
    devbox
    difftastic
    dig
    direnv
    du-dust
    duf
    eternal-terminal
    exa
    fuse-overlayfs
    gcc
    git
    gnumake
    go
    gofumpt
    golangci-lint
    golint
    gopls
    gotools
    grc
    htop
    infra
    jdk
    jq
    julia-bin
    kubectl
    kubernetes-helm
    lazygit
    less
    lesspipe
    lua
    luajitPackages.luarocks
    luajitPackages.tl
    neovim-remote
    nodePackages.eslint
    nodePackages.prettier
    nodejs-18_x
    pass
    php
    php81Packages.composer
    pre-commit
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
    tmate
    tree-sitter
    unzip
    vale
    vault
    wezterm
    wget
    zsh-completions
  ];
}
