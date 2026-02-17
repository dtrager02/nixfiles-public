{ pkgs, pkgs-unstable, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;  # Use the latest VS Code from unstable channel
    mutableExtensionsDir = true;
    profiles.default.extensions = [
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
              name = "theme-dracula";
              publisher = "dracula-theme";
              version = "2.25.1";
              sha256 = "1h3xxwgzgzpwb9fkfl3psm2clvp1jwfhp6asc6chj3cv59v9ncca";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
              name = "copilot";
              publisher = "github";
              version = "1.388.0";
              sha256 = "06dyyp5qb63a7c8sfxbmvz7j405kdw50n7qlp74fl8ydwgrwl67d";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
              name = "copilot-chat";
              publisher = "github";
              version = "0.33.2025103102";
              sha256 = "0c1zmwgipzvg1snpd2j9y0pb3mi3fywklqjm2c1fsf6yxgz3h735";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
              name = "nix-ide";
              publisher = "jnoortheen";
              version = "0.5.0";
              sha256 = "1nx25y6pzcn25yy836kpg55rms4sbzz6kglaillb799c6d1qcnwd";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
              name = "scala";
              publisher = "scala-lang";
              version = "0.5.9";
              sha256 = "05wy2gfz7msfwzy295d9hs1bzgqqz5054kwiwyx5kv6g14msl06f";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
              name = "metals";
              publisher = "scalameta";
              version = "1.59.2";
              sha256 = "0af6babzl12shsxp63vcz81z1xxx2fhl7ds917i262hm9gjjv20b";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
              name = "markdown-all-in-one";
              publisher = "yzhang";
              version = "3.6.3";
              sha256 = "10vfxgw9l3bpihpikc3fhkj6vvd73qgzv168lz1k1m4p0hamp664";
        };
      })
    ];
  };
}
