# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ./boot.nix
  ];

  # Systemd configuration
  systemd = {
    # Make boot faster
    services = {
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online.enable = false;
    };

    user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = [
        "network.target"
        "sound.target"
      ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };
  };

  # Hardware configuration
  hardware = {
    bluetooth = {
      enable = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };

    graphics.enable = true;

    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Networking configuration
  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Services configuration
  services = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    udev.enable = true;
    blueman.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      # Enable automatic login for the user.
      autoLogin = {
        enable = true;
        user = "#########";
      };
    };

    desktopManager.plasma6.enable = true;

    libinput = {
        enable = true;

        # disabling mouse acceleration
        mouse = {
          accelProfile = "flat";
        };

        # disabling touchpad acceleration
        touchpad = {
          accelProfile = "flat";
        };
      };

    # Configure X11 server
    xserver = {
      enable = true;

      # Configure keymap
      xkb = {
        layout = "us";
        variant = "";
      };

      videoDrivers = [ "nvidia" ];
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  security.rtkit.enable = true;

  # Disable auto-mute mode on boot
  systemd.services.disable-auto-mute = {
    description = "Disable ALSA Auto-Mute Mode";
    wantedBy = [ "multi-user.target" ];
    after = [ "sound.target" ];
    path = [ pkgs.alsa-utils ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.alsa-utils}/bin/amixer -c 2 sset 'Auto-Mute Mode' Disabled";
      RemainAfterExit = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.######### = {
    isNormalUser = true;
    description = "#########";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "openrazer"
    ];
    # packages = with pkgs; [
    #   kdePackages.kate
    #   #  thunderbird
    # ];
  };

  # Nix configuration
  nix = {
    # Automatic garabage collections
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    # Enable flakes
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System activation scripts
  system.activationScripts = {
    # Create /bin/bash symlink for external scripts
    binbash = {
      text = ''
        ln -sf ${pkgs.bash}/bin/bash /bin/bash
      '';
    };

    # Sync ######### CA from Firefox to system trust store
    sync#########CA = ''
    CERT_DIR="/etc/ssl/certs"
    NETFLIX_CERT="/var/lib/#########-ca.crt"

    # Find Firefox profile
    FIREFOX_PROFILE=$(find /home/#########/.mozilla/firefox -maxdepth 1 -name "*.default*" -type d 2>/dev/null | head -n 1)

    if [ -n "$FIREFOX_PROFILE" ] && [ -f "$FIREFOX_PROFILE/cert9.db" ]; then
      # Extract ######### CA from Firefox
      ${pkgs.nss.tools}/bin/certutil -L -d sql:$FIREFOX_PROFILE \
        -n '######### Internal Services Root CA V1 - ######### Inc' -a > $NETFLIX_CERT.tmp 2>/dev/null && {
        
        # Only update if certificate changed
        if ! cmp -s $NETFLIX_CERT.tmp $NETFLIX_CERT 2>/dev/null; then
          mv $NETFLIX_CERT.tmp $NETFLIX_CERT
          chmod 644 $NETFLIX_CERT
          echo "######### CA certificate updated from Firefox"
          
          # Trigger system certificate store update
          ${pkgs.coreutils}/bin/ln -sf $NETFLIX_CERT $CERT_DIR/#########-ca.pem
        else
          rm -f $NETFLIX_CERT.tmp
        fi
      } || {
        echo "Warning: Could not extract ######### certificate from Firefox"
        rm -f $NETFLIX_CERT.tmp
      }
    fi
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fio
    kdiskmark
    nil
    nvme-cli
    vesktop
    gnumake
    stress
    # unigine-heaven
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pandas
        requests
        netifaces
        psutil
        selenium
        xdg-base-dirs
      ]
    ))
    openconnect
    pkgs.alsa-utils
    slack
    uv
    openrazer-daemon
    polychromatic
    # chromedriver
    # chromium
  ];

  # In /etc/nixos/configuration.nix
  virtualisation.docker = {
    enable = true;
  };

  # Programs configuration
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nix-ld.enable = true; # enable dynamically linked binaries
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
