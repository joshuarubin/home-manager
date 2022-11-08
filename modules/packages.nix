{pkgs, ...}: let
  bufNoCheck = pkgs.buf.overrideAttrs (_oldAttrs: rec {
    doCheck = false;
  });
in {
  home.packages = with pkgs; [
    act
    alejandra
    aria
    bat
    bufNoCheck
    cargo
    chezmoi
    clippy
    colordiff
    colormake
    curl
    deadnix
    delta
    difftastic
    dig
    du-dust
    duf
    exa
    gcc
    grc
    htop
    jdk
    julia-bin
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
