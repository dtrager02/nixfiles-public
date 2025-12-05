{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nixfmt-rfc-style
    kitty
    openssl
    nss
    docker
    osu-lazer-bin
    libsecret
    vlc
  ];

  home.sessionVariables = {
    EDITOR = "code";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    SHELL = "${pkgs.fish}/bin/fish";
    NIXOS_OZONE_WL = "1";
  };

  home.sessionPath = [ "/home/#########/.local/bin" ];

  # Import modular components
  imports = [
    ./programs/kitty.nix
    ./programs/fish.nix
    ./desktop/plasma.nix
  ];
}
