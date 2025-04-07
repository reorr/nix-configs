{ config, pkgs, lib, ... }:

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
    htop

    # dev
    vscode
    nodejs_22
    go
    gopls
    delve
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
    lsof
    ripgrep
    desktop-file-utils

    # multimedia
    mpv

    # shell
    starship
    zsh-history-substring-search
    zsh-fzf-tab

    # gnome
    dconf-editor
    gnomeExtensions.switcher
    gnomeExtensions.night-theme-switcher
    gnome-power-manager

    # chat
    vesktop
    telegram-desktop

    # downloader
    yt-dlp
    gallery-dl

    # browser
    google-chrome
  ];

  # Other config raw file
  home.file = {
    ghostty = {
      source = ./dotfiles/ghostty;
      target = ".config/ghostty";
    };
    containers = {
      source = ./dotfiles/containers;
      target = ".config/containers";
    };
    nvim = {
      source = ./dotfiles/nvim;
      target = ".config/nvim";
    };
    tmux = {
      source = ./dotfiles/tmux;
      target = ".config/tmux";
    };
    avatar = {
      source = ./dotfiles/avatar.jpg;
      target = ".face";
    };
    swid = {
      source = ./bin/swid;
      target = ".local/bin/swid";
    };
    swin = {
      source = ./bin/swin;
      target = ".local/bin/swin";
    };
  };

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
      # use bash word style
      autoload -U select-word-style
      select-word-style bash

      HISTDUP=erase
      setopt INC_APPEND_HISTORY
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_BEEP

      # load plugins      
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # bind alt+backspace
      bindkey '^[^?' backward-kill-word

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
    profileExtra = lib.mkAfter ''
      rm -rf ${config.home.homeDirectory}/.local/share/applications/home-manager
      rm -rf ${config.home.homeDirectory}/.icons/nix-icons
      ls ${config.home.homeDirectory}/.nix-profile/share/applications/*.desktop > ${config.home.homeDirectory}/.cache/current_desktop_files.txt
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
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        switcher.extensionUuid
        night-theme-switcher.extensionUuid
      ];
      favorite-apps = [
        "org.gnome.Epiphany.desktop"
        "app.zen_browser.zen.desktop"
        "org.gnome.Nautilus.desktop"
        "com.mitchellh.ghostty.desktop"
      ];
    };
    "org/gnome/shell/extensions/switcher" = {
      show-switcher = ["<Super>space"];
      max-width-percentage = lib.hm.gvariant.mkUint32 30;
      font-size = lib.hm.gvariant.mkUint32 16;
      icon-size = lib.hm.gvariant.mkUint32 16;
    };
    "org/gnome/shell/extensions/nightthemeswitcher/commands" = {
      enabled = true;
      sunrise = "swid";
      sunset = "swin";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Super>t";
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionPath = [
    "$HOME/.local/bin/"
  ];

  home.activation = {
    linkDesktopApplications = {
      after = ["writeBoundary" "createXdgUserDirectories"];
      before = [];
      data = ''
        rm -rf ${config.home.homeDirectory}/.local/share/applications/home-manager
        rm -rf ${config.home.homeDirectory}/.icons/nix-icons
        mkdir -p ${config.home.homeDirectory}/.local/share/applications/home-manager
        mkdir -p ${config.home.homeDirectory}/.icons
        ln -sf ${config.home.homeDirectory}/.nix-profile/share/icons ${config.home.homeDirectory}/.icons/nix-icons

        # Check if the cached desktop files list exists
        if [ -f ${config.home.homeDirectory}/.cache/current_desktop_files.txt ]; then
          current_files=$(cat ${config.home.homeDirectory}/.cache/current_desktop_files.txt)
        else
          current_files=""
        fi

        # Symlink new desktop entries
        for desktop_file in ${config.home.homeDirectory}/.nix-profile/share/applications/*.desktop; do
          if ! echo "$current_files" | grep -q "$(basename $desktop_file)"; then
            ln -sf "$desktop_file" ${config.home.homeDirectory}/.local/share/applications/home-manager/$(basename $desktop_file)
          fi
        done

        # Update desktop database
        ${pkgs.desktop-file-utils}/bin/update-desktop-database ${config.home.homeDirectory}/.local/share/applications
      '';
    };
  };
}
