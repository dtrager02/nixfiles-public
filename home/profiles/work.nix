{
  pkgs,
  pkgs-unstable,
  inputs,
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
    profile = "work";
  };

  home.packages = with pkgs; [
    # pkgs-unstable.jetbrains.idea
    # Only install one JDK directly to avoid PATH conflicts
    zulu17
    slack
  ];

  # Set JAVA_HOME to zulu17 by default for Gradle
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.zulu17}";
    BROWSER = "brave";
    NETFLIX_DEV = "true";
  };

  xdg.configFile."mimeapps.list".force = true;

  # Set Brave as default browser for work profile
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Common web content and URL schemes
      "text/html" = "brave-browser.desktop";
      "application/xhtml+xml" = "brave-browser.desktop";
      "application/x-extension-htm" = "brave-browser.desktop";
      "application/x-extension-html" = "brave-browser.desktop";
      "application/x-extension-shtml" = "brave-browser.desktop";
      "application/x-extension-xht" = "brave-browser.desktop";
      "application/x-extension-xhtml" = "brave-browser.desktop";

      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/ftp" = "brave-browser.desktop";
    };
  };
}
