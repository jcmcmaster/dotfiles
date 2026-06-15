{ pkgs, name, email, ... }: {
  home = {
    sessionVariables = {
      "EDITOR" = "nvim";
    };
    stateVersion = "23.11"; # Don't change this
  };

  home.packages = with pkgs; [
    azure-cli # Azure CLI
    bash-language-server # Bash language server
    bat # better cat
    bicep-lsp # Bicep language server
    curl # CLI web client
    docker-language-server # Docker language server
    eslint # JavaScript linter
    fd # better find
    fsautocomplete # F# language server
    graphql-language-service-cli # GraphQL language server
    google-chrome # web browser
    htop # system stats
    jetbrains.rider # C# IDE
    jq # JSON CLI tools
    lemminx # XML language server
    lua-language-server # Lua language server
    obsidian # knowledge management
    powershell-editor-services # PowerShell language server
    pyright # Python language server
    raycast # better runner
    rectangle # window management
    ripgrep # fast grep
    roslyn-ls # C# language server
    terraform # Terraform CLI
    taplo # TOML language server
    tree # directory visualizer
    tree-sitter # AST tools
    vim-language-server # Viml language server
    vscode-css-languageserver # CSS language server
    vscode-json-languageserver # JSON language server
    wget # CLI web client
    yaml-language-server # YAML language server
    yq # YAML CLI tools
  ];

  # friendly interactive shell
  programs.fish = {
    enable = true;
    shellAliases = {
      cd = "z";
      diff = "nvim -d";
      g = "git";
      vi = "nvim";
      vim = "nvim";
    };
    interactiveShellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings

      function fdg -a path depth
        set -q path[1]; or set path ~
        set -q depth[1]; or set depth 1
        set target (fd . $path -t d -d $depth | fzf)
        if set -q target[1]
          z $target
        end
      end

      function fp
        fdg ~/Projects 1
      end

      if test -f $HOME/.corporate-ca.pem
        set -gx NIX_SSL_CERT_FILE $HOME/.combined-ca-bundle.pem
        set -gx SSL_CERT_FILE $HOME/.combined-ca-bundle.pem
        set -gx NODE_EXTRA_CA_CERTS $HOME/.corporate-ca.pem
        set -gx GIT_SSL_CAINFO $HOME/.combined-ca-bundle.pem
      end
    '';
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
  };

  # fuzzy finder
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # Git and gitconfig
  programs.git = {
    enable = true;
    settings = {
      user.name = name;
      user.email = email;
      init.defaultBranch = "main";
      alias = {
        a = "add";
        aa = "add --all";
        acmp = "!f() { git add -A && git commit -m \"$*\" && git push; }; f";
        b = "branch";
        c = "checkout";
        cdd = "checkout -- .";
        cm = "commit --message";
        cmp = "!f() { git commit --message \"$*\" && git push; }; f";
        d = "diff";
        dc = "diff --cached";
        dd = "difftool --dir-diff";
        ddc = "difftool --dir-diff --cached";
        f = "fetch";
        l = "log";
        s = "status";
        sc = "switch -c";
      };
    };
  };

  # Nix Home Manager
  programs.home-manager = {
    enable = true;
  };

  # dependency manager
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # text editor
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    sideloadInitLua = true;
  };

  # pretty prompt
  programs.starship = {
    enable = true;
    presets = [
      "nerd-font-symbols"
   ];
  };

  # heavier text editor
  programs.vscode = {
    enable = true;
  };

  # terminal emulator
  programs.wezterm = {
    enable = true;
  };

  # better cd
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
