{
  description = "My home manager conf";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # openconnect-pulse-launcher = {
    #   url = "github:erahhal/openconnect-pulse-launcher";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # #########-vpn.url = "path:/home/#########/Documents/#########-eng-tools/vpn";
    # #########-vpn.inputs.nixpkgs.follows = "nixpkgs";

    # #########-nixcfg.url = "git+ssh://#########/#########/#########-nixcfg?ref=cef";
    #########-nixcfg.url = "path:/home/#########/workspace/#########-nixcfg";
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Shared ######### modules configuration
      #########Modules = [
        inputs.#########-nixcfg.nixosModules.metatron
        inputs.#########-nixcfg.nixosModules.newt
        inputs.#########-nixcfg.nixosModules.pulse-vpn
        inputs.#########-nixcfg.nixosModules.overlays
        inputs.#########-nixcfg.nixosModules.python
        inputs.#########-nixcfg.nixosModules.weep
        inputs.#########-nixcfg.nixosModules.java
        {
          ######### = {
            username = "#########";
            vpn.pulse = {
              url = "https://pcs.flxvpn.net/emp";
              enable-nm-applet-service = true;
            };
            development.java.enable = true;
          };
        }
      ];
    in
    {
      nixosConfigurations = {
        # Personal configuration - no work tools
        main = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/hosts/my-pc
            ./system/hosts/my-pc/personal.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
              home-manager.users.#########.imports = [
                ./home/profiles/personal.nix
              ];
            }
          ];
        };

        # Work configuration - includes ######### tools
        work = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/hosts/my-pc
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
              home-manager.users.#########.imports = [
                ./home/profiles/work.nix
              ];
            }
          ]
          ++ #########Modules;
        };
      };
    };
}
