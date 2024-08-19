{pkgs, ...}: let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in {
  home.packages = with pkgs; [
    act
    alejandra
    aria2
    asciinema
    asdf-vm
    awscli2
    axel
    azure-cli
    bash
    bat
    bazel
    bc
    bfg-repo-cleaner
    bind
    btop
    buf
    c-ares
    cargo
    clippy
    cmake
    colordiff
    colormake
    corepack
    cpplint
    ctlptl
    curl
    deadnix
    delta
    delve
    deno
    devbox
    difftastic
    dig
    direnv
    docker-buildx
    docker-compose
    docker-credential-helpers
    docutils
    du-dust
    duf
    eternal-terminal
    eza
    fluxcd
    flyctl
    fzf
    gcc
    gdk
    gh
    git
    git-credential-manager
    gitleaks
    glow
    gnumake
    gnupg
    go-task
    go-tools
    gofumpt
    golangci-lint
    golint
    gopls
    goreleaser
    gotools
    graphviz
    grc
    grpc
    grpcurl
    hiera-eyaml
    htop
    inetutils
    ipcalc
    jdk
    jq
    jsonnet
    jsonnet-bundler
    julia-bin
    k9s
    kind
    kubectl
    kubernetes-helm
    kubeseal
    lazygit
    less
    lesspipe
    lua
    luajitPackages.luarocks
    luajitPackages.tl
    mkcert
    mockgen
    mosh
    neovim-remote
    nmap
    nodePackages.cdk8s-cli
    nodePackages.cdktf-cli
    nodePackages.eslint
    nodePackages.prettier
    nodejs_22
    openssl
    opentofu
    pass
    pipx
    pkg-config
    podman
    poetry
    postgresql
    pre-commit
    process-compose
    prometheus
    protobuf
    pulumi-bin
    python3
    python312Packages.fonttools
    python312Packages.identify
    python312Packages.pip
    ran
    redis
    ripgrep
    runme
    rust-analyzer
    rustc
    rustfmt
    safe-rm
    shellcheck
    shfmt
    simplehttp2server
    sipcalc
    spicedb
    spicedb-zed
    sqlc
    sqlfluff
    sshuttle
    statix
    stylua
    tanka
    tmate
    tree-sitter
    unbound
    unzip
    vale
    wdiff
    wezterm
    wget
    wire
    yamllint
    zlib
    zoxide
    zsh-completions
  ];
}
