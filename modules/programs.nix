_: {
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    readline = {
      enable = true;
      includeSystemConfig = false;
      extraConfig = "set editing-mode vi";
    };

    fzf = {
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    go = {
      enable = true;
      goPrivate = [
        "github.com/poolsideai/*"
      ];
    };

    starship = {
      enable = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";

        # add_newline = false;
        # format = "$character";
        # right_format = "$all";

        character = {
          success_symbol = "[λ](bold blue)";
          error_symbol = "[λ](bold red)";
        };

        lua = {
          disabled = true;
        };

        git_state = {
          disabled = true;
        };

        git_commit = {
          disabled = true;
        };

        git_metrics = {
          disabled = true;
        };

        git_branch = {
          disabled = true;
        };

        git_status = {
          disabled = true;
        };

        golang = {
          # symbol = "󰟓 ";
          symbol = " ";
          disabled = true;
        };

        aws = {
          disabled = true;
        };

        nodejs = {
          disabled = true;
        };

        custom.jj = {
          ignore_timeout = true;
          description = "current jj status";
          symbol = "";
          when = true;
          command = ''
            jj root > /dev/null && jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
              separate(" ",
                "🥋",
                change_id.shortest(4),
                bookmarks,
                "|",
                concat(
                  if(conflict, "💥"),
                  if(divergent, "🚧"),
                  if(hidden, "👻"),
                  if(immutable, "🔒"),
                ),
                raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
                raw_escape_sequence("\x1b[1;32m") ++ if(description.first_line(),
                  description.first_line(),
                  "(no description set)",
                ) ++ raw_escape_sequence("\x1b[0m"),
              )
            '
          '';
        };
      };
    };

    gitui = {
      enable = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
