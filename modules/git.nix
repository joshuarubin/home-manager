{pkgs, ...}: {
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

  xdg.configFile."git/message".source = ../files/config/git/message;

  home.packages = [pkgs.git];
}
