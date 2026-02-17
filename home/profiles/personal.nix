{
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ../core.nix
    ../programs/brave.nix
    ../programs/chromium.nix
    ../programs/firefox.nix
    ../programs/vscode.nix
    ../../modules/git.nix
    ../programs/obs.nix
  ];

  programs.git = {
    enable = true;
    profile = "personal";
  };

  home.packages = with pkgs-unstable; [
    osu-lazer-bin
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
  ];

  # Set Firefox as default browser for personal profile
  home.sessionVariables = {
    BROWSER = "firefox";
  };

  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Common web content and URL schemes
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";

      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
    };
  };
}
