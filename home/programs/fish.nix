{ pkgs, lib, ... }:

{
  programs = {
    fish = {
    enable = true;

    # Popular fish shell plugins
    plugins = with pkgs.fishPlugins; [
      {
        name = "tide";
        src = tide.src;
      }
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "colored-man-pages";
        src = colored-man-pages.src;
      }
    ];


    # Abbreviations (like aliases but expand inline)
    shellAbbrs = {
      # Git abbreviations
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      glog = "git log --oneline --graph --decorate";

      # Docker abbreviations
      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      dpsa = "docker ps -a";

      # System abbreviations
      ll = "ls -lah";
      la = "ls -A";
      l = "ls -CF";

      # Nix abbreviations
      ns = "nix-shell";
      nb = "nix-build";
      nf = "nix flake";
    };

    # Custom functions
    functions = {
      # Quick Java version switcher functions
      java8 = {
        description = "Switch to Java 8";
        body = ''
          set -gx JAVA_HOME ${pkgs.zulu8}
          set -gx PATH $JAVA_HOME/bin (string match -v "$JAVA_HOME/bin" $PATH)
          java -version
        '';
      };

      java17 = {
        description = "Switch to Java 17";
        body = ''
          set -gx JAVA_HOME ${pkgs.zulu17}
          set -gx PATH $JAVA_HOME/bin (string match -v "$JAVA_HOME/bin" $PATH)
          java -version
        '';
      };

      java21 = {
        description = "Switch to Java 21";
        body = ''
          set -gx JAVA_HOME ${pkgs.zulu21}
          set -gx PATH $JAVA_HOME/bin (string match -v "$JAVA_HOME/bin" $PATH)
          java -version
        '';
      };

      java23 = {
        description = "Switch to Java 23";
        body = ''
          set -gx JAVA_HOME ${pkgs.zulu23}
          set -gx PATH $JAVA_HOME/bin (string match -v "$JAVA_HOME/bin" $PATH)
          java -version
        '';
      };

      # Create and change to directory
      mkcd = {
        description = "Create a directory and cd into it";
        body = ''
          mkdir -p $argv[1]
          cd $argv[1]
        '';
      };

      # Extract various archive types
      extract = {
        description = "Extract various archive formats";
        body = ''
          if test -f $argv[1]
            switch $argv[1]
              case '*.tar.bz2'
                tar xjf $argv[1]
              case '*.tar.gz'
                tar xzf $argv[1]
              case '*.bz2'
                bunzip2 $argv[1]
              case '*.rar'
                unrar x $argv[1]
              case '*.gz'
                gunzip $argv[1]
              case '*.tar'
                tar xf $argv[1]
              case '*.tbz2'
                tar xjf $argv[1]
              case '*.tgz'
                tar xzf $argv[1]
              case '*.zip'
                unzip $argv[1]
              case '*.Z'
                uncompress $argv[1]
              case '*.7z'
                7z x $argv[1]
              case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
            end
          else
            echo "'$argv[1]' is not a valid file"
          end
        '';
      };

      # Show disk usage of current directory
      dusage = {
        description = "Show disk usage sorted by size";
        body = ''
          du -h -d 1 $argv | sort -h
        '';
      };

      # Quickly find files
      ff = {
        description = "Find files by name";
        body = ''
          find . -type f -iname "*$argv*"
        '';
      };

      # Show PATH entries one per line
      showpath = {
        description = "Show PATH entries one per line";
        body = ''
          echo $PATH | tr ' ' '\n'
        '';
      };

      # Git add, commit with message, and push
      gcp = {
        description = "Git add, commit with message, and push";
        body = ''
          if test (count $argv) -eq 0
            echo "Usage: gcp <commit message>"
            return 1
          end
          git add .
          and git commit -m "$argv"
          and git push
        '';
      };
    };
    };

    bash.enable = true;
    zsh.enable = true;
  };

  # Home activation script to configure Tide on first run
  home.activation.configure-tide = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --rainbow_prompt_char=✓ --rainbow_prompt_right_prefix=Slanted --transient=Yes"
  '';

  home.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake ~/my-home-manager#main";
    nrs-work = "sudo nixos-rebuild switch --flake ~/my-home-manager#work";
    plasmaExport = "nix run github:nix-community/plasma-manager > ~/my-home-manager/home/desktop/plasma.nix";
    "..." = "cd ../..";
    ".." = "cd ..";
    toggle-audio-out = "pactl set-sink-port 0 $(pactl list sinks | awk '/Active Port:/{print $3}' | grep -q 'analog-output-headphones' && echo analog-output-lineout || echo analog-output-headphones)";

     glock="./gradlew deleteLock generateLock saveLock clean build";
      gadd-nolock="find . -type f ! -name '*.lock' -print0 | xargs -0 git add";
      gsa="./gradlew spotlessApply";
      nbs="newt build && newt serve";
      grun="./gradlew bootRun";
      gcb="./gradlew spotlessApply scalafixMain scalafixTest && ./gradlew clean build";
  };
}
