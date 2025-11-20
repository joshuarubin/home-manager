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

        # Jujutsu wrapper with pre-commit hook integration
        jj() {
          # Helper to run git pre-commit hook if it exists
          local run_precommit_hook() {
            local git_dir
            git_dir=$(command jj root 2>/dev/null)/.git
            local hook="$git_dir/hooks/pre-commit"

            if [[ -x "$hook" ]]; then
              echo "Running pre-commit hook..."
              if ! "$hook"; then
                echo "Pre-commit hook failed. Fix issues before proceeding."
                return 1
              fi
            fi
            return 0
          }

          # Helper to check if working copy has changes
          local has_working_copy_changes() {
            command jj diff --summary -r @ 2>/dev/null | grep -q .
          }

          # Find the actual subcommand (skip all flags)
          local subcommand=""
          local git_subcommand=""

          for arg in "$@"; do
            # Skip anything starting with -
            if [[ "$arg" =~ ^- ]]; then
              continue
            fi

            # Found first non-flag argument
            if [[ -z "$subcommand" ]]; then
              subcommand="$arg"
            elif [[ "$subcommand" == "git" && -z "$git_subcommand" ]]; then
              # For "jj git push/fetch/etc"
              git_subcommand="$arg"
              break
            else
              break
            fi
          done

          # Commands that should trigger pre-commit on working copy
          # Trigger on: changing current rev, remote changes, or changing ancestor revs
          case "$subcommand" in
            abandon|commit|edit|new|rebase|split|squash)
              if has_working_copy_changes; then
                run_precommit_hook || return 1
              fi
              ;;
            git)
              if [[ "$git_subcommand" == "push" ]]; then
                # Check if there are any commits to push
                local has_changes
                has_changes=$(command jj log -r 'remote_bookmarks()..@' --limit 1 --no-graph -T 'change_id' 2>/dev/null)

                if [[ -n "$has_changes" ]] && has_working_copy_changes; then
                  run_precommit_hook || return 1
                fi
              fi
              ;;
          esac

          # Execute the actual jj command
          command jj "$@"
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
  };
}
