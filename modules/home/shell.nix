{ config, pkgs, ... }:
let
  commonShellAliases = {
    ding = "mpv ~/Music/notifications/ding-1-14705.mp3 &> /dev/null";
  };
in
{
  programs = {
    fish = {
      enable = false;
      loginShellInit = ''
        set -U fish_greeting
      '';
      plugins = [
        {
          name = "wakatime-fish";
          inherit (pkgs.fishPlugins.wakatime-fish) src;
        }
        {
          name = "grc";
          inherit (pkgs.fishPlugins.grc) src;
        }
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      envExtra = ''
        setopt no_global_rcs
        skip_global_compinit=1
        export SPACESHIP_EXIT_CODE_SHOW=true;
        export LESS='-R -j7';
        export FZF_BASE="${config.home.homeDirectory}/Projects/github.com/junegunn/fzf";
        export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
        export NIXPKGS_ALLOW_UNFREE=1;
        export FZF_CTRL_R_OPTS="$FZF_CTRL_R_OPTS --layout=reverse"

        export ZSH_WAKATIME_PROJECT_DETECTION=true

        zstyle ':completion:*' sort false
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':fzf-tab:*' prefix ' '
        zstyle ':fzf-tab:*' switch-group ',' '.'

        zstyle ':bracketed-paste-magic' active-widgets '.self-*'

        setopt NO_HUP
      '';
      initContent = ''

        ZSH_DISABLE_COMPFIX=true

        autoload -Uz compinit
        for dump in ~/.zcompdump(N.mh+24); do
          compinit
        done
        compinit -C

        DISABLE_AUTO_UPDATE="true"
        DISABLE_MAGIC_FUNCTIONS="true"
        DISABLE_COMPFIX="true"

        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
        ZSH_AUTOSUGGEST_USE_ASYNC=1
      ''
      + ''
        if [[ "$ALACRITTY_SOCKET" != "" && "$TMUX" = "" ]]; then tmux a; fi

      ''
      + ''
        [ -f ~/.zshrc.local ] && source ~/.zshrc.local
      '';

      shellAliases = commonShellAliases // {
        cat = "bat -p";
        vim = "nvim";
        goland = "~/.local/share/JetBrains/Toolbox/apps/goland/bin/goland.sh";
        rustrover = "~/.local/share/JetBrains/Toolbox/apps/rustrover/bin/rustrover.sh";
        clion = "~/.local/share/JetBrains/Toolbox/apps/clion-nova/bin/clion.sh";
        idea = "~/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea.sh";
        magit = ''
          \emacs -Q -nw -l ~/.emacs.d/init-nw.el --funcall magit
        '';
        gpt = "OPENAI_API_KEY=$(cat ~/.config/openai_api_key/key.private) sgpt";
        psgrep = "ps -eF | head -n1 && ps -eF | grep";
        cg = "cd $(git rev-parse --show-toplevel)";
      };
      history = {
        size = 10000000;
        save = 10000000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "man"
          "fzf-tab"
          "zsh-autosuggestions"
          "nix-shell"
          "colored-man-pages"
          "fast-syntax-highlighting"
        ];
        custom = "${config.home.homeDirectory}/.oh-my-zsh/custom";
      };
    };
    bash = {
      enable = true;
      enableCompletion = false;
      enableVteIntegration = true;
      historyFile = "${config.home.homeDirectory}/.bash_history";

      shellAliases = commonShellAliases;
    };
    fzf = {
      enable = true;
      package = pkgs.unstable.fzf;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        command_timeout = 200;
        git_status = {
          disabled = true;
        };
        battery = {
          disabled = true;
        };
      };
    };
  };
}
