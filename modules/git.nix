{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.git;
in
{
  options.programs.git = {
    profile = mkOption {
      type = types.enum [ "personal" "work" ];
      default = "personal";
      description = "Git profile to use (personal or work)";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      userName = "######### #########";
      userEmail = if cfg.profile != "work" 
        then "d#########0#########.com"
        else "#########";
      
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "libsecret";
        safe.directory = "/etc/nixos/";
      };
    };
  };
}
