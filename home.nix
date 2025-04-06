{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "botol";
  home.homeDirectory = "/home/botol";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # misc
    keepassxc
    htop

    # dev
    vscode
    nodejs_22
    go
    httpie
    neovim
    gcc
    gnumake

    # utils
    fzf
    jq
    xz
    unzip
    zip
    fastfetch
    lm_sensors
    usbutils
    pciutils
    gnused
    gnupg
    tmux
    xclip
    gnome-power-manager
    lsof
    ripgrep

    # multimedia
    mpv

    # shell
    starship
    zsh-history-substring-search
    zsh-fzf-tab

    # downloader
    yt-dlp
    gallery-dl
  ];

  # Other config raw file
  home.file.".config/ghostty/config".source = ./ghostty/config;
  home.file.".config/containers".source = ./containers;
  home.file.".config/nvim".source = ./nvim;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [];
    history = {
      size = 100000;
      append = true;
      extended = true;
      ignoreAllDups = true;
    };
    shellAliases = {
      open = "xdg-open";
      grep = "grep -i";
      ccp = "xclip -sel clip";
    };
    sessionVariables = {
      GOPATH = "$HOME/.go";
      EDITOR = "nvim";
    };
    initExtra = ''
      HISTDUP=erase
      setopt INC_APPEND_HISTORY
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_BEEP

      # load plugins      
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # bind arrow left-right
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word

      # bind arrow up-down
      bindkey "^[OA" history-substring-search-up
      bindkey "^[[A" history-substring-search-up
      bindkey "^[OB" history-substring-search-down
      bindkey "^[[B" history-substring-search-down
        '';
  };

  programs.git = {
    enable = true;
    userName = "Muktazam Hasbi Ashidiqi";
    userEmail = "hasbeeazam@gmail.com";
    aliases = {
      co = "checkout";
      s = "status";
      pl = "pull";
      ps = "push";
    };
  };

  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # Gnome related settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-hot-corners = true;
      text-scaling-factor = 1.0;
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
      move-to-workspace-5 = ["<Super><Shift>5"];
      move-to-workspace-6 = ["<Super><Shift>6"];
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 6;
    };
    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
      experimental-features = ["scale-monitor-framebuffer"];
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Epiphany.desktop"
        "app.zen_browser.zen.desktop"
        "org.gnome.Nautilus.desktop"
        "com.mitchellh.ghostty.desktop"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Super>t";
    };
  };

  programs.vscode = {
    enable = true;

    userSettings = {
      update.mode = "none";
      window.zoomLevel = 0;

      terminal.integrated.shell.linux = "${pkgs.zsh}/bin/zsh";

      editor = {
        fontFamily =
          "'JetbrainsMono Nerd Font', 'monospace', monospace, 'Droid Sans Fallback'";
        fontSize = 16;
        fontLigatures = false;
        inlineSuggest.enabled = true;
        bracketPairColorization.enabled = true;
      };
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
