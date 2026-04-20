{ pkgs, username, ... }: {
  home = {
    homeDirectory = "/Users/${username}";
    sessionVariables = {
      "EDITOR" = "nvim";
    };
    stateVersion = "23.11"; # Don't change this
    username = username;
  };

  home.packages = with pkgs; [
    bat
    curl
    fd
    github-cli
    github-copilot-cli
    google-chrome
    htop
    jetbrains.rider
    jq
    obsidian
    raycast
    rectangle
    ripgrep
    spotify
    terraform
    tree
    wget
    yq
  ];

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

      function fpg
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

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Jim McMaster";
      user.email = "jmcmaster008@gmail.com";
      init.defaultBranch = "main";
      alias = {
        a = "add";
        aa = "add --all";
        acp = "!f() { git add -A && git commit -m \"$*\" && git push; }; f";
        b = "branch";
        c = "checkout";
        cdd = "checkout -- .";
        cm = "commit --message";
        d = "diff";
        dc = "diff --cached";
        dd = "difftool --dir-diff";
        ddc = "difftool --dir-diff --cached";
        f = "fetch";
        l = "log";
        s = "status";
      };
    };
    signing.format = "openpgp";
  };

  programs.gpg = {
    enable = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
  };

  programs.starship = {
    enable = true;
    presets = [
      "nerd-font-symbols"
   ];
  };

  programs.wezterm = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
