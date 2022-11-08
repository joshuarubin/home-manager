{pkgs, ...}: let
  bufNoCheck = pkgs.buf.overrideAttrs (_oldAttrs: rec {
    doCheck = false;
  });
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jrubin";
  home.homeDirectory = "/home/jrubin";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    cdpath = ["." "$HOME" "$HOME/dev"];
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
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
      searchDownKey = "^[OB";
      searchUpKey = "^[OA";
    };

    initExtraFirst = ''
      . $HOME/.nix-profile/etc/profile.d/nix.sh
      export NIX_PATH=$HOME/.nix-defexpr/channels
      export GPG_TTY="$(tty)"; # put this here and not in sessionVariables to ensure it gets reexecuted for all interactive shells
    '';

    initExtra = ''
      path=(
        "''${HOME}/.local/bin"
        $path
      )

      setopt ALWAYS_TO_END          # Move cursor to the end of a completed word
      setopt AUTO_CD
      setopt AUTO_PUSHD             # Push the current directory visited on the stack
      setopt AUTO_RESUME            # Attempt to resume existing job before creating a new process
      setopt COMBINING_CHARS        # Combine zero-length punctuation characters (accents) with the base character
      setopt COMPLETE_IN_WORD       # Complete from both ends of a word
      setopt CORRECT
      setopt EXTENDED_GLOB          # Needed for file modification glob modifiers with compinit
      setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format
      setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history
      setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate
      setopt HIST_REDUCE_BLANKS
      setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file
      setopt INTERACTIVE_COMMENTS
      setopt LONG_LIST_JOBS         # List jobs in the long format by default
      setopt PATH_DIRS              # Perform path search even on command names with slashes
      setopt PUSHD_IGNORE_DUPS      # Do not store duplicates in the stack
      setopt PUSHD_SILENT           # Do not print the directory stack after pushd or
      setopt PUSHD_TO_HOME
      setopt RC_QUOTES              # Allow two single quotes to signify a single quote within singly quoted strings
      setopt SHARE_HISTORY          # Share history between all sessions

      unsetopt BG_NICE      # Don't run all background jobs at a lower priority
      unsetopt CASE_GLOB
      unsetopt CLOBBER
      unsetopt FLOW_CONTROL # Disable start/stop characters in shell editor
      unsetopt LIST_BEEP
      unsetopt NOMATCH

      autoload -Uz edit-command-line && zle -N edit-command-line
      autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
      autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

      bindkey          " "       magic-space
      bindkey          "^?"      backward-delete-char # backspace
      bindkey          "^F"      fzf-file-widget
      bindkey          "^X^E"    edit-command-line
      bindkey          "^[."     insert-last-word  # meta-.
      bindkey          "^[OC"    forward-char      # Right
      bindkey          "^[OD"    backward-char     # Left
      bindkey          "^[OF"    end-of-line       # End
      bindkey          "^[OH"    beginning-of-line # Home
      bindkey          "^[[3~"   delete-char
      bindkey          "^[[5~"   up-line-or-history    # PageUp
      bindkey          "^[[6~"   down-line-or-history  # PageDown
      bindkey          "^[[Z"    reverse-menu-complete # Shift-Tab
      bindkey          "^[_"     insert-last-word # meta-_
      bindkey          "^[Oc"    forward-word # ctrl-right
      bindkey          "^[Od"    backward-word # ctrl-left
      bindkey          "^[[1;5C" forward-word # ctrl-right
      bindkey          "^[[1;5D" backward-word # ctrl-left
      bindkey          "^[[5C"   forward-word # ctrl-right
      bindkey          "^[[5D"   backward-word # ctrl-left
      bindkey -M vicmd "v"       edit-command-line
      bindkey -M viins "^A"      vi-beginning-of-line
      bindkey -M viins "^B"      vi-backward-char
      bindkey -M viins "^E"      vi-end-of-line
      bindkey -M viins "^H"      backward-delete-char
      bindkey -M viins "^K"      kill-line
      bindkey -M viins "^N"      down-history
      bindkey -M viins "^N"      up-history
      bindkey -M viins "^P"      up-history
      bindkey -M viins "^U"      backward-kill-line
      bindkey -M viins "^W"      backward-kill-word
      bindkey -M viins "^Y"      yank
      bindkey -M viins "^_"      undo
      bindkey -M viins '^[b'     backward-word # meta-b
      bindkey -M viins '^[d'     kill-word     # meta-d
      bindkey -M viins '^[f'     forward-word  # meta-f

      bindkey -r "^T" # remove default fzf-file-widget bind

      prompt_lean_precmd_patch () {
        # use λ instead of % for prompt
        PROMPT="''${PROMPT:s/%#/%(\!.#.λ)/}"
      }

      zle-keymap-select () {
        prompt_lean_precmd
        prompt_lean_precmd_patch
        zle reset-prompt
      }

      autoload -Uz add-zsh-hook
      add-zsh-hook precmd prompt_lean_precmd_patch

      . $HOME/.nix-profile/etc/grc.zsh

      [ -s "$BASE16_SHELL/profile_helper.sh" ] && eval "$("$BASE16_SHELL/profile_helper.sh")"

      ls () {
        local args=(--git -g --group-directories-first --icons)
        if [ "$1" = "-ltr" -o "$1" = "-lrt" ]; then
          args=($args -lsnew ''${@:2})
        elif [ "$1" = "-ltra" -o "$1" = "-lrta" ]; then
          args=($args -lsnew -a ''${@:2})
        else
          args=($args $@)
        fi
        exa ''${args}
      }

      env () {
        command env "$@" | sort | grcat conf.env
      }

      take () {
        mkdir -p $@ && cd ''${@:$#}
      }

      server () {
        if [ "''${1}" = "-h" ]; then
          echo "server <PORT>|-h" 1>&2
          echo "runs the 'ran' web server for the current directory" 1>&2
          return
        fi

        PORT=''${1}
        if [ -z "''${PORT}" ]; then PORT=8000; fi

        ran --port "''${PORT}" --listdir
      }

      diff () {
        command diff --unified "$@" | colordiff --difftype diffu
      }
    '';

    # TODO(jawa) review completion

    # TODO(jawa)
    # NOTE: these are not exported
    localVariables = {
      BASE16_SHELL = "$HOME/.config/base16-shell/";
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND = "fg=yellow,bold";
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND = "bg=red,bold";
      KEYTIMEOUT = "1";
      PROMPT_LEAN_VIMODE = "1";
      WORDCHARS = "*?_-.[]~&;!#$%^(){}<>"; # remove =/ from the list
    };

    # envExtra = "";
    # loginExtra = "";
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
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    aliases = {
      sts = "status";
      st = "status";
      ci = "commit -s";
      am = "am -s";
      di = "diff";
      dis = "diff";
      co = "checkout";
      br = "branch";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      patch = "--no-pager diff --no-color";
    };

    delta = {
      enable = true;

      options = {
        side-by-side = true;
        features = "decorations";
        syntax-theme = "gruvbox-dark";
        navigate = true;

        decorations = {
          commit-style = "bold yellow";
          file-style = "bright-yellow";
          hunk-header-style = "bold syntax";
          minus-style = "syntax '#340001'";
          minus-non-emph-style = "bold red";
          minus-emph-style = "bold red 52";
          minus-empty-line-marker-style = "normal '#3f0001'";
          zero-style = "normal";
          plus-style = "syntax '#012800'";
          plus-non-emph-style = "bold green";
          plus-emph-style = "bold green 22";
          plus-empty-line-marker-style = "normal '#002800'";
          whitespace-error-style = "reverse purple";
          line-numbers-minus-style = "88";
          line-numbers-zero-style = "'#444444'";
          line-numbers-plus-style = "28";
          line-numbers-left-style = "blue";
          line-numbers-right-style = "blue";
        };
      };
    };

    extraConfig = {
      apply = {
        whitespace = "nowarn";
      };

      help = {
        autocorrect = 1;
      };

      push = {
        default = "upstream";
        followTags = true;
        autoSetupRemote = true;
      };

      pull = {
        ff = "only";
      };

      tag = {
        sort = "version:refname";
        forceSignAnnotated = true;
      };

      rerere = {
        enabled = true;
      };

      protocol = {
        keybase = {
          allow = "always";
        };
      };

      init = {
        defaultBranch = "main";
      };

      credential = {
        helper = "/usr/local/share/gcm-core/git-credential-manager-core";
      };

      commit = {
        template = "~/.config/git/message";
      };
    };

    ignores = [
      "tmp"
      ".envrc"
      ".stignore"
      ".stversions/"
      "*.zwc"
      "*.zwc.old"
      ".mypy_cache/"
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon\r\r"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
      "*~"
      ".directory"
      ".Trash-*"
      "Thumbs.db"
      "ehthumbs.db"
      "Desktop.ini"
      "$RECYCLE.BIN/"
      "*.cab"
      "*.msi"
      "*.msm"
      "*.msp"
      "*.lnk"
      ".hg/"
      ".hgignore"
      ".hgsigs"
      ".hgsub"
      ".hgsubstate"
      ".hgtags"
      ".svn/"
      "/CVS/*"
      "*/CVS/*"
      ".cvsignore"
      "*/.cvsignore"
      "[._]*.s[a-w][a-z]"
      "#[._]s[a-w][a-z]"
      "*.un~"
      "Session.vim"
      ".netrwhist"
      "*~"
      "*.tmlanguage.cache"
      "*.tmPreferences.cache"
      "*.stTheme.cache"
      "*.sublime-workspace"
      "sftp-config.json"
      "TAGS"
      ".TAGS"
      "!TAGS/"
      "tags"
      ".tags"
      "!tags/"
      "gtags.files"
      "GTAGS"
      "GRTAGS"
      "GPATH"
      "cscope.files"
      "cscope.out"
      "cscope.in.out"
      "cscope.po.out"
      ".zfs/"
      ".notags"
    ];

    includes = [
      {
        condition = "hasconfig:remote.*.url:https://github.com/**";
        contents = {
          credential = {
            username = "joshuarubin";
            credentialStore = "gpg"; # TODO(jawa) this depends on os
          };
        };
      }
      {
        condition = "hasconfig:remote.*.url:https://github.com/groq-psw/**";
        contents = {
          user = {
            email = "jrubin@groq.com";
          };

          credential = {
            username = "jrubin_groq";
            credentialStore = "gpg"; # TODO(jawa) this depends on os
          };
        };
      }
    ];

    lfs.enable = true;

    signing = {
      signByDefault = true;
      key = "50116F3E17627303"; # TODO(jawa)
    };

    userEmail = "me@jawa.dev";
    userName = "Joshua Rubin";
  };

  programs.go = {
    enable = true;
    goPrivate = ["github.com/groq-psw"];
  };

  # TODO(jawa) zstyle

  # NOTE: these are exported
  home.sessionVariables = {
    # MAKEFLAGS = "-j <numcpu>"; # TODO(jawa)
    # SSH_AUTH_SOCK = ""; # TODO(jawa)
    EDITOR = "nvim";
    GREP_COLOR = "1;33";
    GREP_COLORS = "mt=\${GREP_COLOR}";
    LESS = "-F -g -i -M -R -X";
    LESSOPEN = "| lesspipe.sh %s";
    PAGER = "less";
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
    chmod = "chmod --preserve-root -v";
    chown = "chown --preserve-root -v";
    cp = "nocorrect cp -i";
    df = "duf --hide-mp '*.zfs/snapshot/*,*/keybase/*' --hide special";
    du = "dust";
    find = "noglob find";
    g = "git";
    gbr = "git branch";
    gc = "git commit --signoff --verbose";
    gcc = "nocorrect gcc";
    gcm = "git commit --signoff --message";
    gco = "git checkout";
    get = "aria2c --max-connection-per-server=5 --continue";
    gf = "git fetch";
    gfm = "git pull --no-rebase";
    gia = "git add";
    gl = "git log --topo-order --prety=fuller";
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
    listeners = "sudo lsof -nPiTCP -sTCP:LISTEN";
    ln = "nocorrect ln -i";
    locate = "noglob locate";
    make = "colormake";
    man = "nocorrect man";
    mkdir = "nocorrect mkdir -p";
    mv = "nocorrect mv -i";
    rm = "nocorrect safe-rm";
    rsync = "noglob rsync";
    top = "htop";
    v = "ls -l";
  };

  home.file = {
    ".ripgreprc".text = ''
      --smart-case
      --hidden
    '';

    ".vale.ini" = {
      text = ''
        StylesPath = styles

        MinAlertLevel = suggestion
        Vocab = Base

        Packages = Google, proselint, write-good, alex, Readability

        [*]
        BasedOnStyles = alex, proselint
      '';
      onChange = "vale sync";
    };

    ".actrc".text = ''
      -P ubuntu-latest=catthehacker/ubuntu:act-latest
      -P ubuntu-22.04=catthehacker/ubuntu:act-22.04
      -P ubuntu-20.04=catthehacker/ubuntu:act-20.04
      -P ubuntu-18.04=catthehacker/ubuntu:act-18.04
    '';
  };

  xdg.configFile = {
    "git/message".text = ''
      # If applied, this commit will...


      # Why was this change made?


      # Any references to tickets, articles, etc?
    '';
  };

  home.packages = with pkgs; [
    act
    alejandra
    aria
    bat
    bufNoCheck
    cargo
    chezmoi
    clippy
    colordiff
    colormake
    curl
    deadnix
    delta
    difftastic
    dig
    du-dust
    duf
    exa
    gcc
    git
    grc
    htop
    julia-bin
    less
    lesspipe
    lua
    luajitPackages.luarocks
    luajitPackages.tl
    nodePackages.eslint
    nodePackages.prettier
    nodejs-16_x
    oraclejdk
    pass
    php
    php81Packages.composer
    pre-commit
    python310Full
    ran
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    safe-rm
    shellcheck
    shfmt
    sqlfluff
    statix
    stylua
    terraform
    tree-sitter
    unzip
    vale
    wget
    zsh-completions
  ];
}
