{ pkgs, pkgs-unstable, inputs, ... }:

{
  imports = [
    ../core.nix
    ../programs/brave.nix
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
    pkgs-unstable.jetbrains.idea-ultimate
    # Only install one JDK directly to avoid PATH conflicts
    zulu17
    inputs.openconnect-pulse-launcher.packages."${pkgs.system}".openconnect-pulse-launcher
  ];

  # Set JAVA_HOME to zulu17 by default for Gradle
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.zulu17}";
  };
}
