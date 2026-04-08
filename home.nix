{
  pkgs,
  pkgsUnstable,
  ...
}:
# let
#   op-cred-helper = pkgs.writeShellApplication {
#     name = "op-cred-helper";
#     runtimeInputs = [ pkgs._1password-cli ];
#     text = ''
#       vault="$1"
#       secret_id="$2"
#       cat <<END | op inject
#       {
#         "Version": 1,
#         "AccessKeyId": "{{ op://''${vault}/''${secret_id}/access key id }}",
#         "SecretAccessKey": "{{ op://''${vault}/''${secret_id}/secret access key }}"
#       }
#       END
#     '';
#   };
# in
{
  ##################################################################################################
  ### Configuring Nix + Home-Manager
  ##################################################################################################

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  ##################################################################################################
  ### Env Vars
  ##################################################################################################

  home.sessionVariables = {
    EDITOR = "vi";
  };

  ##################################################################################################
  ### Configurable Home-Manager Services + Packages (alphabetical)
  ##################################################################################################

  ## See available configuration options at either:
  ## * Search - https://home-manager-options.extranix.com
  ## * Manual - https://nix-community.github.io/home-manager/options.xhtml

  ## TODO Enable and check
  programs.awscli.enable = true;
  programs.awscli = {
    # credentials = {
    #   "default" = {
    #       # https://tenmilesquare.com/resources/security/how-to-use-1password-to-securely-store-your-aws-credentials/
    #       "credential_process" = "${op-cred-helper}/bin/op-cred-helper 'CLI Accessible' 'S3 Dev bucket access key'";
    #       "region" = "us-west-2";
    #   };
    # };
    # Configuration written to $HOME/.aws/config.
    # settings = {
    #   "default" = {
    #     region = "us-west-2";
    #     output = "json";
    #   };
    # };
  };

  programs.bash.enable = true;
  programs.bash = {
    profileExtra = builtins.readFile ./bash_profile;
    initExtra = builtins.readFile ./bashrc;

    ## Per https://github.com/nix-community/home-manager/issues/3133#issuecomment-1320315536
    # turn off the automated completion injection
    enableCompletion = false;

    # 1. Manually import completions using `-z` to check if it's been loaded instead of `-v`
    # 2. Add nix binaries to PATH (for some reason not getting set elsewhere?)
    bashrcExtra = ''
      if [[ -z BASH_COMPLETION_VERSINFO ]]; then
        . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
      fi

      # export PATH="/run/current-system/sw/bin:$PATH"
      # export PATH="/etc/profiles/per-user/jdoe/bin:$PATH"

      export PATH="/opt/homebrew/bin:$PATH"
      # export PATH="/opt/homebrew/bin/opt/postgresql@14/bin:$PATH"
      # export LDFLAGS="-L/usr/local/opt/postgresql@14/lib"
      # export CPPFLAGS="-I/usr/local/opt/postgresql@14/include"

      export PATH="$HOME/.ghcup/bin:$PATH"
      export PATH=$PATH:$HOME/go/bin
      export PATH=$PATH:$HOME/.cargo/bin
    '';

    ## Per https://github.com/nix-community/home-manager/blob/bb4b25b302dbf0f527f190461b080b5262871756/modules/programs/bash.nix#L86
    # Modify default option set to remove macOS-incompatible options
    shellOptions = [
      # Append to history file rather than replacing it.
      "histappend"

      # check the window size after each command and, if
      # necessary, update the values of LINES and COLUMNS.
      "checkwinsize"

      # Extended globbing.
      "extglob"
      # "globstar"  # unavailable on macOS

      # Warn if closing shell with running jobs.
      # "checkjobs"  # unavailable on macOS
    ];
  };

  # programs.direnv.enable = true;
  # programs.direnv = {
  #   nix-direnv.enable = true;

  #   enableBashIntegration = true;
  #   enableNushellIntegration = true;
  # };

  programs.eza.enable = true;
  programs.eza = {
    git = true;
    # enableBashIntegration = true;
    # enableNushellIntegration = true;
  };

  programs.fish.enable = true;

  programs.fzf.enable = true;
  programs.fzf = {
    enableBashIntegration = true;
  };

  # programs.ghostty.enable = false; # currently marked 'broken'
  # programs.ghostty = {
  #   enableBashIntegration = true;
  #   installBatSyntax = true;
  # settings = {
  #   theme = "catppuccin-mocha";
  #   font-size = 10;
  #   keybind = [
  #     "ctrl+h=goto_split:left"
  #     "ctrl+l=goto_split:right"
  #   ];
  # };
  #
  # themes = {
  #   catppuccin-mocha = {
  #     background = "1e1e2e";
  #     cursor-color = "f5e0dc";
  #     foreground = "cdd6f4";
  #     palette = [
  #       "0=#45475a"
  #       "1=#f38ba8"
  #       "2=#a6e3a1"
  #       "3=#f9e2af"
  #       "4=#89b4fa"
  #       "5=#f5c2e7"
  #       "6=#94e2d5"
  #       "7=#bac2de"
  #       "8=#585b70"
  #       "9=#f38ba8"
  #       "10=#a6e3a1"
  #       "11=#f9e2af"
  #       "12=#89b4fa"
  #       "13=#f5c2e7"
  #       "14=#94e2d5"
  #       "15=#a6adc8"
  #     ];
  #     selection-background = "353749";
  #     selection-foreground = "cdd6f4";
  #   };
  # };
  # };

  # Gitconfig written to ~/.config/git/config
  programs.git.enable = true;
  programs.git = {
    includes = [{path = "~/.config/nixpkgs/gitconfig";}];
    ignores = [
      ".DS_Store"
      "*.local"
      "*.pem"
      "*.p8"
      ".claude"
      "*scratch/"
    ];
    settings = {
      user.email = "foo@bar.com";
      user.name = "Heneli";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
  };

  programs.java.enable = true;

  programs.jq.enable = true;

  # Settings adapted from https://github.com/the-argus/nixsys/blob/74ee1dd0ac503e241581ee8c3d7b719fa4305e1e/user/primary/lf.nix#L46
  programs.lf.enable = true;
  programs.lf = {
    settings = {
      drawbox = true;
      dirfirst = true;
      icons = true;
      ignorecase = true;
      preview = true;
    };
  };

  # Use NVF instead of home-manager module for neovim
  # programs.neovim.enable = true;
  # programs.neovim = {
  #   defaultEditor = false;
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  #
  #   extraPackages = [ ];
  #   extraPython3Packages = ps: [ ];
  #   plugins = with pkgs.vimPlugins; [
  #     telescope-nvim
  #   ];
  # };

  # Build time warnings - 
  # bad JSON log message from the derivation builder: [json.exception.parse_error.101] 
  # parse error at line 1, column 55: syntax error while parsing value - invalid string: missing closing quote; last read: '"neovimRequireCheckHo'
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      # General
      theme.enable = true;
      treesitter.enable = true;
      lsp.enable = true;
      lsp.formatOnSave = true;

      # Languages - base settings
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        # Nix - nil LSP (nixpkgs-fmt is archived, alejandra is default)
        nix = {
          enable = true;
          extraDiagnostics.enable = true;
          format.type = ["alejandra"];
          lsp.enable = true;
          lsp.servers = ["nil"];
        };

        # Python - ruff + basedpyright (open-source pylance equivalent)
        python = {
          enable = true;
          format.type = [
            "ruff"
            "ruff-check"
            "isort"
          ];
          lsp.enable = true;
          lsp.servers = ["basedpyright"];
        };

        # Rust - rust-analyzer + rustfmt + crates.nvim
        rust = {
          enable = true;
          extensions.crates-nvim.enable = true;
          format.type = ["rustfmt"];
          lsp.enable = true;
        };

        # TypeScript/JS - ts_ls + prettier + eslint
        ts = {
          enable = true;
          extraDiagnostics.enable = true;
          format.type = ["prettier"];
          lsp.enable = true;
          lsp.servers = ["ts_ls"];
        };
      };

      # Git (similar to GitLens)
      git = {
        gitsigns.enable = true;
        vim-fugitive.enable = true;
      };

      # UI enhancements
      ui = {
        illuminate.enable = true; # highlight word under cursor
        breadcrumbs.enable = true; # navbuddy - code outline navigation (like aerial)
      };

      # Keybinding hints (like which-key)
      binds.whichKey.enable = true;

      # Completion (blink-cmp - faster than nvim-cmp)
      autocomplete.blink-cmp.enable = true;

      # Statusline
      statusline.lualine.enable = true;

      # Multi-purpose search and picker utility
      telescope.enable = true;

      minimap = {
        minimap-vim.enable = true;
        codewindow.enable = true;
      };
    };
  };

  programs.nix-index.enable = true;
  programs.nix-index = {
    enableBashIntegration = true;
  };

  # Pretty dataframe manipulation of shell commands with polars
  programs.nushell.enable = true;
  programs.nushell = {
    extraConfig = ''
      $env.config = {
        show_banner: false,
      }
    '';
  };

  programs.pylint.enable = true;
  programs.pylint = {
    settings = {};
  };

  programs.ripgrep.enable = true;

  programs.ripgrep-all.enable = true;

  programs.spotify-player.enable = true;

  programs.tmux.enable = true;
  programs.tmux = {
    mouse = true;
  };

  programs.vscode.enable = true;
  programs.vscode = {
    # https://github.com/nix-community/home-manager/issues/3507
    # https://github.com/nix-community/home-manager/issues/4394#issuecomment-1712909231
    # programs.vscode.mutableExtensionsDir can be used only if no profiles apart from default are set.
    mutableExtensionsDir = false;
  };
  programs.vscode.profiles.default = {
    enableUpdateCheck = false; # yolo
    enableExtensionUpdateCheck = true;
  };
  programs.vscode.profiles.default = {
    userSettings = {
      "editor" = {
        "fontSize" = 18;
        "formatOnPaste" = true;
        "tabSize" = 2;
        "rulers" = [100];
      };
      "files.trimTrailingWhitespace" = false;
      "markdown.preview.doubleClickToSwitchToEditor" = false;
      "markdown.preview.openMarkdownLinks" = "inEditor";
      "[markdown]" = {
        "editor.unicodeHighlight.allowedCharacters" = {
          "’" = true;
        };
        "editor.wordWrap" = "on";
      };
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "nix.enableLanguageServer" = true; # Enable LSP.
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = ["nixpkgs-fmt"];
          };
        };
      };
      "svelte.enable-ts-plugin" = true;
      "window.titleBarStyle" = "native";
    };

    extensions =
      # TODO Requires stable and unstable nixpkgs
      # with pkgs-unstable.vscode-extensions; [
      #   # Jinja Templating
      #   samuelcolvin.jinjahtml # *.{sql,js,etc}.jinja syntax highlighting)
      # ] ++
      (with pkgs.vscode-extensions; [
        # Nix
        bbenoist.nix
        jnoortheen.nix-ide
        # mkhl.direnv

        # Rust
        rust-lang.rust-analyzer

        # Python
        charliermarsh.ruff
        ms-python.python
        ms-python.vscode-pylance

        # JS + TS
        esbenp.prettier-vscode
        svelte.svelte-vscode

        # Documentation
        unifiedjs.vscode-mdx
        yzhang.markdown-all-in-one

        # Configuration
        tamasfe.even-better-toml

        # Serialization Formats
        mechatroner.rainbow-csv

        # Infra
        hashicorp.terraform

        # Themes

        # Version Control
        eamodio.gitlens
        github.vscode-github-actions
        github.vscode-pull-request-github

        # General
      ])
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "capnp";
          publisher = "norgor";
          version = "0.2.1";
          sha256 = "sha256-ruKtc/mBr2Ric3PJI21S4+GGGCuRMVt+6pqYkXNWmB0=";
        }
        {
          # Automatically load environments with direnv
          name = "claude-code";
          publisher = "anthropic";
          version = "1.0.31";
          sha256 = "sha256-3brSSb6ERY0In5QRmv5F0FKPm7Ka/0wyiudLNRSKGBg=";
        }
        {
          # Automatically load environments with direnv
          name = "direnv";
          publisher = "mkhl";
          version = "0.17.0";
          sha256 = "sha256-T+bt6ku+zkqzP1gXNLcpjtFAevDRiSKnZaE7sM4pUOs=";
        }
        {
          # TODO Get from pkgs-unstable
          # Jinja Templating: *.{sql,js,etc}.jinja syntax highlighting
          name = "jinjahtml";
          publisher = "samuelcolvin";
          version = "0.20.0";
          sha256 = "sha256-wADL3AkLfT2N9io8h6XYgceKyltJCz5ZHZhB14ipqpM=";
        }
        {
          # A full-featured WYSIWYG editor for markdown
          name = "markdown-editor"; # configure in vscode's settings.json through nix
          publisher = "zaaack";
          version = "0.1.10";
          sha256 = "sha256-K1nczR059BsiHpT1xdtJjpFLl5krt4H9+CrEsIycq9U=";
        }
        {
          # Pretty Typescript Errors
          name = "pretty-ts-errors";
          publisher = "yoavbls";
          version = "0.5.4";
          sha256 = "sha256-SMEqbpKYNck23zgULsdnsw4PS20XMPUpJ5kYh1fpd14=";
        }
        {
          # Python Virtual Env Locator (useful for monorepos)
          name = "python-envy";
          publisher = "teticio";
          version = "0.1.11";
          sha256 = "sha256-grkusc1UWWxpD25f4bnoBSumjwKuIum+jRMJ+gt1d94=";
        }
        {
          # importing 📤 viewing 🔎 slicing 🔪 dicing 🎲 charting 📊 & exporting 📥 large .json array
          # .arrow .avro .parquet data files, .config .env .properties .ini .yml configurations
          # files, .csv/.tsv & .xlsx/.xlsb Excel files and .md markdown tables
          name = "vscode-data-preview";
          publisher = "randomfractalsinc";
          version = "2.3.0";
          sha256 = "sha256-hKnAKdt0splUFyN8n9IdTD8NKjahIMMrLkkwg55zWv0=";
        }
      ];
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.zsh.enable = false;
}
