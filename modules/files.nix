_: {
  home.file.".ripgreprc".source = ../files/ripgreprc;

  home.file.".vale.ini" = {
    source = ../files/vale.ini;
    onChange = "vale sync";
  };

  home.file.".actrc".source = ../files/actrc;

  home.file.".ignore".source = ../files/ignore;

  home.file.".terminfo.wezterm" = {
    source = ../files/wezterm.terminfo;
    onChange = "tic -x -o ~/.terminfo ~/.terminfo.wezterm";
  };

  home.file.".gnupg/gpg-agent.conf".source = ../files/gnupg/gpg-agent.conf;
}
