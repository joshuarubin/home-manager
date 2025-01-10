{
  gpgKey,
  lib,
  pkgs,
  system,
  sysConfig,
  ...
}: {
  home.file = {
    ".actrc".source = ../files/actrc;
    ".aws/config".source = ../files/aws/config;
    ".bash_profile".source = ../files/bash_profile;
    ".bashrc".source = ../files/bashrc;
    ".ctags".source = ../files/ctags;
    ".editrc".source = ../files/editrc;
    ".gnupg/dirmngr.conf".source = ../files/gnupg/dirmngr.conf;
    ".gnupg/gpg-agent.conf".text = lib.optionalString (system == "aarch64-darwin") "pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac\n" + (builtins.readFile ../files/gnupg/gpg-agent.conf);
    ".gnupg/gpg.conf".text =
      ''
        default-key ${gpgKey}
        local-user ${gpgKey}
        encrypt-to ${gpgKey}
      ''
      + (builtins.readFile ../files/gnupg/gpg.conf);
    ".grc" = {
      source = ../files/grc;
      recursive = true;
    };
    ".hushlogin".text = "";
    ".ignore".source = ../files/ignore;
    ".mdl.rb".source = ../files/mdl.rb;
    ".mdlrc".source = ../files/mdlrc;
    ".npmrc".text = "prefix=${sysConfig.homeDirectory}/.local/share/npm";
    ".ripgreprc".source = ../files/ripgreprc;
    ".stylelintrc".source = ../files/stylelintrc;
    ".terminfo.wezterm" = {
      source = ../files/wezterm.terminfo;
      onChange = "tic -x -o ~/.terminfo ~/.terminfo.wezterm";
    };
    ".zprofile".source = ../files/zprofile;
    ".zsh/functions".source = ../files/zsh/functions;
  };

  xdg.configFile = {
    "atuin/config.toml".source = ../files/config/atuin/config.toml;
    "flake8".source = ../files/config/flake8;
    "git/template/hooks/pre-commit".source = ../files/config/git/template/hooks/pre-commit;
    "nixpkgs/config.nix".source = ../files/config/nixpkgs/config.nix;
    "pylintrc".source = ../files/config/pylintrc;
    "safe-rm".source = ../files/config/safe-rm;
    "wezterm" = {
      source = ../files/config/wezterm;
      recursive = true;
    };
    "yamllint/config".source = ../files/config/yamllint/config;
    "vale/.vale.ini" = {
      source = ../files/vale.ini;
      onChange = "${pkgs.vale}/bin/vale sync";
    };
  };
}
