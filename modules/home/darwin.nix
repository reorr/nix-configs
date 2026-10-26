{ ... }:

{
  imports = [ ./common.nix ];

  home.stateVersion = "24.11";

  # nix-darwin normally adds this via /etc/zshenv; ensure it is present anyway.
  home.sessionPath = [ "/etc/profiles/per-user/ulatbulu/bin" ];

  home.file = {
    ".config/ghostty/config".source = ../../dotfiles/ghostty/config;
    # ".config/tmux/tmux.conf".source = ../../dotfiles/tmux/tmux.conf;
    ".config/nvim".source = ../../dotfiles/nvim;
    ".config/containers".source = ../../dotfiles/containers;
    ".config/omniwm/settings.toml".source = ../../dotfiles/omniwm/settings.toml;
    ".config/sketchybar".source = ../../dotfiles/sketchybar;
  };
}
