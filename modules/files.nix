{
  lib,
  pkgs,
  system,
  ...
}: {
  home.file = {
    ".ripgreprc".source = ../files/ripgreprc;

    ".vale.ini" = {
      source = ../files/vale.ini;
      onChange = "vale sync";
    };

    ".actrc".source = ../files/actrc;

    ".ignore".source = ../files/ignore;

    ".terminfo.wezterm" = {
      source = ../files/wezterm.terminfo;
      onChange = "tic -x -o ~/.terminfo ~/.terminfo.wezterm";
    };

    ".gnupg/gpg-agent.conf".text = lib.optionalString (system == "aarch64-darwin") "pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac\n" + (builtins.readFile ../files/gnupg/gpg-agent.conf);

    ".zsh/functions".source = ../files/zsh/functions;

    ".config/git/template/hooks/pre-commit".source = ../files/git/template/hooks/pre-commit;
  };
}
