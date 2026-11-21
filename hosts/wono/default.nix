{ pkgs, config, ... }:

{
  system.primaryUser = "ulatbulu";

  users.knownUsers = [ "ulatbulu" ];
  users.users.ulatbulu = {
    uid = 501;
    gid = 20;
    home = "/Users/ulatbulu";
  };

  # Touch ID for sudo (nix-darwin manages /etc/pam.d/sudo_local).
  security.pam.services.sudo_local.touchIdAuth = true;

  services.sketchybar = {
    enable = true;
    # 2.24.0 mispositions the bar under the menu bar on macOS 26 external displays;
    # the fix is in 2.24.1 (nixpkgs still ships 2.24.0).
    package = pkgs.sketchybar.overrideAttrs (_: {
      version = "2.24.1";
      src = pkgs.fetchFromGitHub {
        owner = "FelixKratz";
        repo = "SketchyBar";
        rev = "v2.24.1";
        hash = "sha256-fEbVzafjFTigR7TjQ41gOnDpk6S4B8qCwpz890ZNgwE=";
      };
    });
    # Config lives in ~/.config/sketchybar (HM). Empty `config` => not managed here.
    extraPackages = [ pkgs.jq ];
  };

  # Re-theme sketchybar when wallpaper changes; also runs at login.
  launchd.user.agents.sketchybar-wallpaper-colors = {
    path = [ pkgs.matugen "/run/current-system/sw/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" ];
    command = "${config.users.users.ulatbulu.home}/.config/sketchybar/wallpaper-colors.sh";
    serviceConfig = {
      RunAtLoad = true;
      WatchPaths = [
        "${config.users.users.ulatbulu.home}/Library/Application Support/com.apple.wallpaper/Store"
        "${config.users.users.ulatbulu.home}/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
      ];
      ThrottleInterval = 2;
      LimitLoadToSessionType = "Aqua";
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };
    taps = [
      "abue-ammar/tinycast"
      "anomalyco/tap"
      "subhashhhhhh/tether"
    ];
    brews = [
      "composer"
      "fnm"
      "gradle"
      "herdr"
      "incus"
      "libpq@16"
      "lsusb"
      "mise"
      "mole"
      "openjdk@21"
      "pgcli"
      "php-cs-fixer"
      "php@8.3"
      "rtk"
      "anomalyco/tap/opencode-v2"
      "rjyo/moshi/moshi-hook"
      "wakeonlan"
    ];
    casks = [
      "bruno"
      "dbeaver-community"
      "dbx"
      "devtoys"
      "font-maple-mono"
      "font-maple-mono-nf"
      "font-maple-mono-nf-cn"
      "ghostty"
      "obs"
      "orbstack"
      "postman"
      "tether"
      "tinycast"
      "utm"
      "wifiman"
      "wireshark-app"
    ];
  };
}
