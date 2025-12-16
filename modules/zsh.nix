{
  config,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    cdpath = ["." "$HOME" "$HOME/dev/poolside" "$HOME/dev"];
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    defaultKeymap = "viins";

    plugins = [
    ];

    history = {
      save = 50000;
      size = 50000;
    };

    historySubstringSearch = {
      enable = true;
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        export ASDF_DATA_DIR=$HOME/.local/share/asdf
        export NIX_PATH=$HOME/.nix-defexpr/channels
        export GPG_TTY="$(tty)"; # put this here and not in sessionVariables to ensure it gets reexecuted for all interactive shells
        export FPATH

        fpath=(
          "$HOME/.zsh/functions"
          "$HOME/.local/share/asdf/completions"
          $fpath
        )

        autoload -Uz $fpath[1]/*(.:t)

        # Nix cleanup function - keep last N generations
        nix-clean() {
          local keep=''${1:-5}
          local gens=$(home-manager generations | awk '{print $5}' | sort -rn)
          local total=$(echo "$gens" | wc -l | tr -d ' ')
          local to_remove=$(echo "$gens" | tail -n +$((keep + 1)))

          if [[ $total -le $keep ]]; then
            echo "Only $total generations exist, keeping all"
          else
            echo "Removing $((total - keep)) old generations (keeping last $keep)"
            echo "$to_remove" | xargs -r home-manager remove-generations
          fi

          nix-collect-garbage -d
          nix-store --optimise
        }

        # Light version without optimize
        nix-clean-light() {
          local keep=''${1:-5}
          local gens=$(home-manager generations | awk '{print $5}' | sort -rn)
          local total=$(echo "$gens" | wc -l | tr -d ' ')
          local to_remove=$(echo "$gens" | tail -n +$((keep + 1)))

          if [[ $total -le $keep ]]; then
            echo "Only $total generations exist, keeping all"
          else
            echo "Removing $((total - keep)) old generations (keeping last $keep)"
            echo "$to_remove" | xargs -r home-manager remove-generations
          fi

          nix-collect-garbage -d
        }
      '')
      (builtins.readFile ../files/zshrc)
    ];

    # TODO(jawa) review completion

    # TODO(jawa)
    # NOTE: these are not exported
    localVariables = {
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND = "fg=yellow,bold";
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND = "bg=red,bold";
      KEYTIMEOUT = "1";
      WORDCHARS = "*?_-.[]~&;!#$%^(){}<>"; # remove =/ from the list
      ZSH_AUTOSUGGEST_MANUAL_REBIND = 1;
    };

    # envExtra = "";
    # loginExtra = "";
  };

  # TODO(jawa) zstyle

  # NOTE: these are exported
  home.sessionVariables = {
    # NOTE change $PATH in zshrc
    # MAKEFLAGS = "-j <numcpu>"; # TODO(jawa)
    EDITOR = "nvim";
    GOPROXY = "https://proxy.golang.org,direct";
    GOSUMDB = "sum.golang.org";
    GREP_COLOR = "1;33";
    GREP_COLORS = "mt=\${GREP_COLOR}";
    LESS = "-F -g -i -M -R -X";
    LESSOPEN = "| lesspipe.sh %s";
    LS_COLORS = "di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:";
    PAGER = "less";
    PKG_CONFIG_PATH = "${config.home.profileDirectory}/lib/pkgconfig";
    RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    VISUAL = "nvim";
    WINEARCH = "win32";
    YAMLFIX_SECTION_WHITELINES = "1";
    XZ_DEFAULTS = "--threads=0";
  };

  home.shellAliases = {
    # nvim # TODO(jawa)
    # tmux # TODO(jawa)
    bazel = "bazelisk";
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
    terraform = "tofu";
    tf = "tofu";
    top = "htop";
    tree = "ls --tree";
    v = "ls -l";
    vimdiff = "nvim -d";

    # Nix cleanup aliases
    nix-gc = "nix-collect-garbage -d";
    hm = "home-manager";

    # jj (Jujutsu VCS) aliases - call jj config aliases where available
    jjb = "jj bookmark";
    jjbc = "jj bc";  # expands to: jj bookmark create
    jjbl = "jj bl";  # expands to: jj bookmark list
    jjbm = "jj bm";  # expands to: jj bookmark move
    jjbs = "jj bs";  # expands to: jj bookmark set
    jjd = "jj d";  # expands to: jj diff --ignore-all-space
    jjdesc = "jj describe";
    jjds = "jj ds";  # expands to: jj log --no-graph --template description
    jjdsc = "jj dsc";  # expands to: jj log -r @ --no-graph --template description
    jje = "jj e";  # expands to: jj edit
    jjgf = "jj gf";  # expands to: jj git fetch
    jjgp = "jj gp";  # expands to: jj git push
    jjl = "jj l";  # expands to: jj log
    jjla = "jj la";  # expands to: jj log -r 'all()'
    jjlb = "jj lb";  # expands to: jj log -r '(main..@):: | (main..@)-'
    jjn = "jj n";  # expands to: jj new
    jjr = "jj r";  # expands to: jj rebase
    jjs = "jj s";  # expands to: jj status
    jjsh = "jj sh";  # expands to: jj show
  };
}
