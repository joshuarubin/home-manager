_: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.readline = {
    enable = true;
    includeSystemConfig = false;
    extraConfig = "set editing-mode vi";
  };

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
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.go = {
    enable = true;
    goPrivate = ["github.com/groq-psw"];
  };
}
