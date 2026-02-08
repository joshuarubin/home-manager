{
  pkgs,
  gpgKey,
  ...
}: {
  programs.git = {
    enable = true;

    settings = {
      alias = {
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

      user = {
        email = "me@jawa.dev";
        name = "Joshua Rubin";
      };

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
        templateDir = "~/.config/git/template";
      };

      credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };

      commit = {
        template = "~/.config/git/message";
      };

      merge = {
        tool = "nvimdiff2";
      };
    };

    ignores = [
      "!TAGS/"
      "!tags/"
      "#[._]s[a-w][a-z]"
      "$RECYCLE.BIN/"
      "build/"
      "*.cab"
      "*.http"
      "*.lnk"
      "*.msi"
      "*.msm"
      "*.msp"
      "*.stTheme.cache"
      "*.sublime-workspace"
      "*.tmPreferences.cache"
      "*.tmlanguage.cache"
      "*.un~"
      "*.zwc"
      "*.zwc.old"
      "*/.cvsignore"
      "*/CVS/*"
      "*~"
      "*~"
      ".AppleDB"
      ".AppleDesktop"
      ".AppleDouble"
      ".DS_Store"
      ".DocumentRevisions-V100"
      ".LSOverride"
      ".Spotlight-V100"
      ".TAGS"
      ".TemporaryItems"
      ".Trash-*"
      ".Trashes"
      ".VolumeIcon.icns"
      "._*"
      ".apdisk"
      ".claude/settings.local.json"
      ".opencode/"
      ".cvsignore"
      ".directory"
      ".envrc"
      ".fseventsd"
      ".hg/"
      ".hgignore"
      ".hgsigs"
      ".hgsub"
      ".hgsubstate"
      ".hgtags"
      ".luarc.json"
      ".mypy_cache/"
      ".netrwhist"
      ".notags"
      ".project"
      ".stignore"
      ".stversions/"
      ".svn/"
      ".tags"
      ".zfs/"
      "/CVS/*"
      "AGENTS.md"
      "CLAUDE.md"
      "Desktop.ini"
      "GPATH"
      "GRTAGS"
      "GTAGS"
      "Icon\r\r"
      "Network Trash Folder"
      "Session.vim"
      "TAGS"
      "Temporary Items"
      "Thumbs.db"
      "[._]*.s[a-w][a-z]"
      "cscope.files"
      "cscope.in.out"
      "cscope.out"
      "cscope.po.out"
      "ehthumbs.db"
      "gtags.files"
      "sftp-config.json"
      "tags"
      "tmp"
    ];

    includes = [
      {
        condition = "hasconfig:remote.*.url:https://github.com/runstateops/**";
        contents = {
          user = {
            email = "joshua@runstateops.com";
          };
        };
      }
      {
        condition = "hasconfig:remote.*.url:https://github.com/**";
        contents = {
          credential = {
            username = "joshuarubin";
          };
        };
      }
    ];

    lfs.enable = true;

    signing = {
      signByDefault = true;
      key = gpgKey;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

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

  xdg.configFile."git/message".source = ../files/config/git/message;
}
