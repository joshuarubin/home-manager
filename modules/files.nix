_: {
  home.file.".ripgreprc".source = ../files/ripgreprc;

  home.file.".vale.ini" = {
    source = ../files/vale.ini;
    onChange = "vale sync";
  };

  home.file.".actrc".source = ../files/actrc;

  home.file.".ignore".source = ../files/ignore;
}
