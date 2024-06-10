{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    cdpath = ["." "$HOME" "$HOME/dev/groq" "$HOME/dev/cloud" "$HOME/dev"];
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    defaultKeymap = "viins";

    plugins = [
      {
        name = "lean";
        src = pkgs.fetchFromGitHub {
          owner = "miekg";
          repo = "lean";
          rev = "a9cb0229dbfbaa8eb92ecc04672ab54176adc19d";
          sha256 = "03awPTFjHqijcGKjAUyovugG7cejkeqbeqt0hjSMznM=";
        };
      }
    ];

    history = {
      save = 50000;
      size = 50000;
    };

    historySubstringSearch = {
      enable = true;
    };

    initExtraFirst = ''
      export NIX_PATH=$HOME/.nix-defexpr/channels
      export GPG_TTY="$(tty)"; # put this here and not in sessionVariables to ensure it gets reexecuted for all interactive shells
      export FPATH

      fpath=(
        "$HOME/.zsh/functions"
        $fpath
      )
    '';

    initExtra = builtins.readFile ../files/zshrc;

    # TODO(jawa) review completion

    # TODO(jawa)
    # NOTE: these are not exported
    localVariables = {
      BASE16_SHELL = "$HOME/.config/base16-shell/";
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND = "fg=yellow,bold";
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND = "bg=red,bold";
      KEYTIMEOUT = "1";
      PROMPT_LEAN_NOTITLE = "1";
      PROMPT_LEAN_VCS = 0;
      PROMPT_LEAN_VIMODE = "1";
      WORDCHARS = "*?_-.[]~&;!#$%^(){}<>"; # remove =/ from the list
      ZSH_AUTOSUGGEST_MANUAL_REBIND = 1;
    };

    # envExtra = "";
    # loginExtra = "";
  };

  # TODO(jawa) zstyle

  # NOTE: these are exported
  home.sessionVariables = {
    # MAKEFLAGS = "-j <numcpu>"; # TODO(jawa)
    # SSH_AUTH_SOCK = ""; # TODO(jawa)
    EDITOR = "nvim";
    GOPROXY = "https://proxy.golang.org,direct";
    GOSUMDB = "sum.golang.org";
    GREP_COLOR = "1;33";
    GREP_COLORS = "mt=\${GREP_COLOR}";
    LESS = "-F -g -i -M -R -X";
    LESSOPEN = "| lesspipe.sh %s";
    LS_COLORS = "di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:";
    PAGER = "less";
    PATH = "$HOME/go/bin:$PATH";
    RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    VISUAL = "nvim";
    WINEARCH = "win32";
    XZ_DEFAULTS = "--threads=0";
  };

  home.shellAliases = {
    # nvim # TODO(jawa)
    # tmux # TODO(jawa)
    c = "clear";
    cat = "bat";
    cd = "nocorrect cd";
    cdc = "cd && clear";
    chmod = "chmod -v";
    chown = "chown -v";
    cp = "nocorrect cp -i";
    df = "duf --hide-mp '*.zfs/snapshot/*,*/keybase/*' --hide special";
    du = "dust";
    find = "noglob find";
    g = "git";
    gbr = "git branch";
    gc = "git commit --signoff --verbose";
    gcam = "git commit --signoff --verbose --all --message";
    gcc = "nocorrect gcc";
    gcm = "git commit --signoff --message";
    gco = "git checkout";
    get = "aria2c --max-connection-per-server=5 --continue";
    gf = "git fetch";
    gfm = "git pull --no-rebase";
    gia = "git add";
    gl = "git log --topo-order --pretty=fuller";
    glg = "git log --graph --pretty=oneline";
    glo = "git log --topo-order --pretty=oneline";
    gm = "git merge";
    gp = "git push";
    gr = "gr --slack --label=.Infra --require-clean --update-mr";
    grep = "grep --color=auto";
    gs = "git stash";
    gsp = "git stash pop";
    gwd = "git diff"; # TODO(jawa) --no-ext-diff
    gws = "git status";
    history = "noglob history";
    ip = "ip --color=auto";
    k = "kubectl";
    listeners = "sudo lsof -nPiTCP -sTCP:LISTEN +c0";
    ln = "nocorrect ln -i";
    locate = "noglob locate";
    make = "colormake";
    man = "nocorrect man";
    mkdir = "nocorrect mkdir -p";
    mv = "nocorrect mv -i";
    rm = "nocorrect safe-rm";
    rsync = "noglob rsync";
    tf = "terraform";
    top = "htop";
    tree = "ls --tree";
    v = "ls -l";
  };
}
