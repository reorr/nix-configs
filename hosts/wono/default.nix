{ pkgs, ... }:

{
  system.primaryUser = "ulatbulu";

  users.knownUsers = [ "ulatbulu" ];
  users.users.ulatbulu = {
    uid = 501;
    gid = 20;
    home = "/Users/ulatbulu";
  };

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
      "php@8.4"
      "rtk"
      "anomalyco/tap/opencode-v2"
      "rjyo/moshi/moshi-hook"
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
