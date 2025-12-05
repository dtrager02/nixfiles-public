{ ... }:

{
  imports = [
    ../core.nix
    ../programs/brave.nix
    ../programs/firefox.nix
    ../programs/vscode.nix
    ../../modules/git.nix
  ];

  programs.git = {
    enable = true;
    profile = "personal";
  };
}
