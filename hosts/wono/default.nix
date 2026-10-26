{ ... }:

{
  system.primaryUser = "ulatbulu";

  users.knownUsers = [ "ulatbulu" ];
  users.users.ulatbulu = {
    uid = 501;
    gid = 20;
    home = "/Users/ulatbulu";
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
      "lxc"
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
      "wifiman"
      "wireshark-app"
    ];
  };
}
