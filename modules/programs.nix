_: {
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    readline = {
      enable = true;
      includeSystemConfig = false;
      extraConfig = "set editing-mode vi";
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    fzf = {
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    go = {
      enable = true;
      goPrivate = [
        "github.com/poolsideai/*"
      ];
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;

        format = "$character";
        right_format = "$all";

        character = {
          success_symbol = "[λ](bold blue)";
          error_symbol = "[λ](bold red)";
        };
      };
    };

    gitui = {
      enable = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
