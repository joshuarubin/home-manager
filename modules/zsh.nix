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
    completionInit = ''
      # Smart compinit with caching
      # Only run security check once per day, otherwise use cached version
      autoload -Uz compinit
      local zcompdump="''${ZDOTDIR:-$HOME}/.zcompdump"
      if [[ -f "$zcompdump" && $(date -r "$zcompdump" +%s 2>/dev/null || echo 0) -gt $(($(date +%s) - 86400)) ]]; then
        # Dump is less than 24h old, skip security check
        compinit -C
      else
        # Regenerate and check
        compinit
      fi
    '';
    syntaxHighlighting = {
      enable = false; # Manually loaded with deferred loading for faster startup
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

        # Source all rc.d scripts
        for rcfile in "$HOME"/.zsh/rc.d/*.zsh(N); do
          source "$rcfile"
        done
      '')
      (builtins.readFile ../files/zshrc)
      (lib.mkAfter ''
        # Source all after.d scripts (after compinit)
        for rcfile in "$HOME"/.zsh/after.d/*.zsh(N); do
          source "$rcfile"
        done

        # Deferred loading of syntax highlighting for faster startup
        # This loads highlighting after the first prompt appears
        _zsh_defer_syntax_highlighting() {
          # Find the syntax highlighting plugin
          local zsh_syntax_highlighting
          for dir in /nix/store/*-zsh-syntax-highlighting-*/share/zsh-syntax-highlighting; do
            if [[ -f "$dir/zsh-syntax-highlighting.zsh" ]]; then
              zsh_syntax_highlighting="$dir/zsh-syntax-highlighting.zsh"
              break
            fi
          done

          if [[ -n "$zsh_syntax_highlighting" ]]; then
            source "$zsh_syntax_highlighting"
          fi

          # Remove this hook after first run
          add-zsh-hook -d precmd _zsh_defer_syntax_highlighting
        }

        # Schedule syntax highlighting to load after first prompt
        autoload -Uz add-zsh-hook
        add-zsh-hook precmd _zsh_defer_syntax_highlighting
      '')
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
  };
}
