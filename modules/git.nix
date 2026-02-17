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
      settings = {
        user = {
          name = "######### #########";
          email = if cfg.profile == "work" 
            then "#########"
            else "#########";
        };
        init.defaultBranch = "main";
        credential.helper = "libsecret";
        safe.directory = "/etc/nixos/";
      };
    };
  };
}
