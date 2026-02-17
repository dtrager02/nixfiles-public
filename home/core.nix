{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nixfmt-rfc-style
    kitty
    openssl
    nss
    docker
    libsecret
    vlc
    pulseaudio  # Provides pactl for PipeWire
    scala-cli
  ];

  home.sessionVariables = {
    EDITOR = "code";
    TERMINAL = "kitty";
    SHELL = "${pkgs.fish}/bin/fish";
    NIXOS_OZONE_WL = "1";
  };

    programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # ######### SSH Configuration
    extraConfig = ''
      # Use "nfsuper" by default for ######### nodes. Note that we can't just put this in the block below because the %r parameter passed to pilgrim would not pick it up.
      Match Host %*,i-*,????????-????-????-????-????????????,100.*,f???.??????*,g???.??????*,!fw??.??????*
          User nfsuper

      # Default to root for OC aliases and workbench instances
      Match Host c???.??????.*,*.workbench.prod.#########.net,*.workbench.test.#########.net
      	User root

      Match Host %* exec "bash /home/#########/.ssh/instance-ssh.sh %p %r %h /tmp/pilgrim/%C"
          UserKnownHostsFile ~/.ssh/#########_known_hosts
          Include /tmp/pilgrim/%C/config

      Match Host i-*,????????-????-????-????-????????????,c???.??????.*,f???.??????.dev*,f???.??????.gamedev*,f???.??????.staging*,f???.??????.ops*,f???.??????.ix*,f???.??????.isp*,g???.??????.dev*,g???.??????.gamedev*,g???.??????.staging*,g???.??????.ops*,g???.??????.ix*,g???.??????.isp*,!fw??.??????*,100.* exec "bash -c 'test -z $NFSSH_DISABLED && test -z $NFSSH_NEWT_DISABLED && metatron -n pilgrim --targetPath /tmp/pilgrim/%C --user %r --instanceId %h'"
          UserKnownHostsFile ~/.ssh/#########_known_hosts
          Include /tmp/pilgrim/%C/config

      Match OriginalHost 100.* exec "bash -c 'test -z $NFSSH_DISABLED && test $NFSSH_NEWT_DISABLED && metatron -n pilgrim --targetPath /tmp/pilgrim/%C --user %r --instanceIp %h'"
          UserKnownHostsFile ~/.ssh/#########_known_hosts
          Include /tmp/pilgrim/%C/config

      Match Host *.workbench.prod.#########.net,*.workbench.test.#########.net exec "bash -c 'test -z $NFSSH_DISABLED && test -z $NFSSH_NEWT_DISABLED && taskId=$(NEWT_QUIET=1 newt workbench-lookup -f {{.TitusTaskId}}  %h | tail -n 1) && metatron -n pilgrim --targetPath /tmp/pilgrim/%C --user %r --instanceId $taskId'"
          UserKnownHostsFile ~/.ssh/#########_known_hosts
          Include /tmp/pilgrim/%C/config

      # Enables SSH to remote workspaces: https://manuals.#########.net/view/workspaces/mkdocs/main/howto/ssh-into-workspaces/
      Match Host work.* exec "work prepare-ssh /tmp/work/config"
          Include /tmp/work/config
    '';

    matchBlocks = {
      "bastion-jump.cluster.us-west-2.prod.cloud.#########.net" = {
        addressFamily = "inet";
        user = "jump";
        identityFile = "~/.metatron/certificates/mtssh_rsa";
        identitiesOnly = true;
        extraOptions = {
          UserKnownHostsFile = "~/.ssh/#########_known_hosts";
          StrictHostKeyChecking = "yes";
          CheckHostIP = "no";
        };
      };

      "remote-devtools.prod.#########.net" = {
        user = "d#########";
        identityFile = "~/.metatron/certificates/mtssh_rsa";
        identitiesOnly = true;
        extraOptions = {
          UserKnownHostsFile = "~/.ssh/#########_known_hosts";
          StrictHostKeyChecking = "yes";
          CheckHostIP = "no";
        };
      };

      "aws*.prod.#########.net aws*.test.#########.net aws*.mgmt.#########.net aws*.seg.#########.net awstest awsprod awsmgmt awsseg awsstudioengineering" = {
        user = "d#########";
        identityFile = "~/.metatron/certificates/mtssh_rsa";
        identitiesOnly = true;
      };

      "pylon scicomp2 *.pylon.prod.container.dataeng.#########.net *.scicomp2.prod.container.dataeng.#########.net" = {
        user = "root";
        identityFile = "~/.metatron/certificates/mtssh_rsa";
        identitiesOnly = true;
        extraOptions = {
          UserKnownHostsFile = "~/.ssh/pylon_known_hosts";
        };
      };

      "github.com" = {
        identityFile = "~/.ssh/githubpublickey";
      };

      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };

  services.ssh-agent.enable = true;

  home.sessionPath = [ "/home/#########/.local/bin" ];

  # Import modular components
  imports = [
    ./programs/kitty.nix
    ./programs/fish.nix
    ./desktop/plasma.nix
  ];
}
