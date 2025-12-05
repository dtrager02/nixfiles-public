{
  description = "My home manager conf";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    openconnect-pulse-launcher = {
      url = "github:erahhal/openconnect-pulse-launcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #########-newt.url = "path:/home/#########/Documents/#########-eng-tools/newt";
    #########-newt.inputs.nixpkgs.follows = "nixpkgs";
    #########-metatron.url = "path:/home/#########/Documents/#########-eng-tools/metatron";
    #########-metatron.inputs.nixpkgs.follows = "nixpkgs";
    #########-vpn.url = "path:/home/#########/Documents/#########-eng-tools/vpn";
    #########-vpn.inputs.nixpkgs.follows = "nixpkgs";

    # #########-nixcfg.url = "git+ssh://#########/corp/#########-nixcfg";
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
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      # Get base undetected-chromedriver before any overlays
      basePkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkNixosConfig =
        profile: workModules:
        nixpkgs.lib.nixosSystem {
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
                ./home/profiles/${profile}.nix
              ];
            }
          ]
          ++ workModules;
        };
    in
    {
      nixosConfigurations = {
        main = mkNixosConfig "personal" [ ];

        work = mkNixosConfig "work" [

          inputs.#########-newt.nixosModules.default
          inputs.#########-metatron.nixosModules.default
          inputs.#########-vpn.nixosModules.default
          {
            # Start by installing VPN only -> Connect to VPN -> enable the other flakes as they depend on a VPN connection
            services.#########.newt.enable = true;
            services.#########.metatron.enable = true;
            # VPN module doesn't have an enable option - it's always active when imported
          }
          # inputs.#########-nixcfg.nixosModules.git
          # inputs.#########-nixcfg.nixosModules.metatron
          # inputs.#########-nixcfg.nixosModules.newt
          # inputs.#########-nixcfg.nixosModules.pulse-vpn
          # inputs.#########-nixcfg.nixosModules.python
          # {
          #   ######### = {
          #     # Needed for home-manager
          #     username = "#########";
          #   };

          #   # Make openconnect-pulse-launcher available and replace chromedriver with undetected-chromedriver
          #   nixpkgs.overlays = [
          #     (final: prev: {
          #       openconnect-pulse-launcher =
          #         inputs.openconnect-pulse-launcher.packages."${system}".openconnect-pulse-launcher;
          #       chromedriver = basePkgs.undetected-chromedriver;
          #     })
          #   ];
          # }
        ];
      };
    };
}
