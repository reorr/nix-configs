{ pkgs, ... }:

let
  zshrc = ''
    export ZSH="$HOME/.oh-my-zsh"

    plugins=(docker history-substring-search zsh-autosuggestions zsh-syntax-highlighting fzf fzf-tab)

    fpath+="''${ZSH_CUSTOM:-"$ZSH/custom"}/plugins/zsh-completions/src"

    source $ZSH/oh-my-zsh.sh

    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down

    HISTSIZE=100000
    HISTFILE=~/.zsh_history
    SAVEHIST=$HISTSIZE
    HISTDUP=erase
    setopt INC_APPEND_HISTORY
    setopt EXTENDED_HISTORY
    setopt APPEND_HISTORY
    setopt SHARE_HISTORY
    setopt HIST_EXPIRE_DUPS_FIRST
    setopt HIST_IGNORE_DUPS
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_SPACE
    setopt HIST_FIND_NO_DUPS
    setopt HIST_SAVE_NO_DUPS
    setopt HIST_BEEP

    eval "`fnm env`"

    ssh-add --apple-load-keychain -q

    eval "$(starship init zsh)"

    export PATH="$HOME/go/bin:$PATH"

    # Added by Antigravity
    export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="/opt/homebrew/opt/libpq@16/bin:$PATH"

    # bun completions
    [ -s "/Users/ulatbulu/.bun/_bun" ] && source "/Users/ulatbulu/.bun/_bun"

    # bun
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    # Added by codebase-memory-mcp install
    export PATH="/Users/ulatbulu/.local/bin:$PATH"

    # Mise
    eval "$(mise activate zsh)"

    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';
in
{
  home.packages = with pkgs; [
    aria2
    bat
    btop
    cloudflared
    dive
    fzf
    glow
    grpcurl
    hey
    httpie
    iperf3
    just
    jq
    jwt-cli
    redis
    uv
    watch
    wget
    yt-dlp
    prettyping
    scrcpy
  ];

  home.sessionPath = [ "$HOME/.local/bin/" ];

  # oh-my-zsh's fzf plugin needs the fzf share dir; nix fzf isn't in its search list.
  home.sessionVariables.FZF_BASE = "${pkgs.fzf}/share/fzf";

  # oh-my-zsh handles completion; keep HM from adding a second compinit.
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    initExtra = zshrc;
    envExtra = ''. "$HOME/.cargo/env"'';
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"

      # Added by OrbStack: command-line tools and integration
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    '';
  };

  programs.starship = {
    enable = true;
    # Already initialised in initExtra; avoid a second `starship init zsh`.
    enableZshIntegration = false;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };
}
