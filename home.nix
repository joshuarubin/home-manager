{pkgs, ...}: let
  bufNoCheck = pkgs.buf.overrideAttrs (_oldAttrs: rec {
    doCheck = false;
  });
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jrubin";
  home.homeDirectory = "/home/jrubin";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # TODO(jawa)
  targets.genericLinux.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    defaultOptions = [
      "--height 40%"
      "--reverse"
      "--border"
      "--inline-info"
      "--ansi"
      "--color fg:-1,bg:-1,hl:67,fg+:110,bg+:-1,hl+:67,info:229,prompt:242,pointer:73,marker:131,spinner:240"
    ];
    fileWidgetCommand = "rg --files --hidden";
    historyWidgetOptions = ["--exact"];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.go = {
    enable = true;
    goPrivate = ["github.com/groq-psw"];
  };

  home.file = {
    ".ripgreprc".source = ./files/ripgreprc;

    ".vale.ini" = {
      source = ./files/vale.ini;
      onChange = "vale sync";
    };

    ".actrc".source = ./files/actrc;
  };

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
    julia-bin
    less
    lesspipe
    lua
    luajitPackages.luarocks
    luajitPackages.tl
    nodePackages.eslint
    nodePackages.prettier
    nodejs-16_x
    oraclejdk
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
