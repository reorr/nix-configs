{ lib, ... }:

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
    ".config/omniwm/settings.base.toml".source = ../../dotfiles/omniwm/settings.toml;
    ".config/sketchybar".source = ../../dotfiles/sketchybar;
    ".config/matugen".source = ../../dotfiles/matugen;
  };

  # OmniWM rewrites settings.toml itself, so it must be a real file rather than
  # a store symlink. Seed it from the repo copy and apply the wallpaper accent.
  home.activation.omniwmSettings = lib.hm.dag.entryAfter [ "linkGeneration" "installPackages" ] ''
    run mkdir -p "$HOME/.config/omniwm"
    run rm -f "$HOME/.config/omniwm/settings.toml"
    run install -m 600 "$HOME/.config/omniwm/settings.base.toml" "$HOME/.config/omniwm/settings.toml"
    run "$HOME/.config/sketchybar/wallpaper-colors.sh" || true
  '';
}
