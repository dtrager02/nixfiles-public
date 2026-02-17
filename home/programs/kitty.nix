{ lib, pkgs, ... }:

{
  programs.kitty = lib.mkForce {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "1.0";
      background_blur = 5;
    };
    enableGitIntegration = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMonoNL NF";
      size = 13;
    };
    themeFile = "VSCode_Dark";
  };
}
