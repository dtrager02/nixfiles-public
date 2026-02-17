{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
# https://stackoverflow.com/questions/8946325/chrome-extension-id-how-to-find-it
{

  programs.chromium = {
    enable = true;
    package = pkgs-unstable.brave;

    # https://www.reddit.com/r/NixOS/comments/1bqilmi/how_to_configure_brave_browser_package_to_install/
    # Look at the url for the ids
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # Ublock
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # Sponsor Block
      { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # Privacy Badger
      { id = "mplblehnmghjbogbmlhmdfiimmmckgco"; } # Go link assistant
    ];


    commandLineArgs = [
        # ---- CERTIFICATES ----
        # Use NSS certificate database (same as Firefox) for ######### internal certs
        "--use-system-default-cert-store"

        # ---- PERFORMANCE ----
        "--disable-background-networking"
        "--disable-breakpad"
        "--disable-crash-reporter"

        # ---- PRIVACY ----
        "--disable-sync"
        "--disable-domain-reliability"

        # ---- WAYLAND SUPPORT ----
        # Uncomment the following lines if you use Wayland
        # Note: Can also be enabled globally via: environment.sessionVariables.NIXOS_OZONE_WL = "1";
        "--ozone-platform=wayland"

        # ---- HARDWARE ACCELERATION ----
        # Enable VA-API for hardware video decoding (requires VA-API drivers)
        # Check chrome://gpu to verify it's working
        # Note: Multiple --enable-features and --disable-features must be combined into single flags
        "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder,HttpsOnlyMode"
        "--disable-features=UseChromeOSDirectVideoDecoder,MediaRouter"

        # GPU flags
        "--enable-zero-copy"
        "--disable-gpu-compositing"

        # ---- APPEARANCE ----
        # Force dark mode for all websites
        "--force-dark-mode"

        # ---- OTHER OPTIONS ----
        # Start in incognito mode (uncomment if desired)
        # "--incognito"

        # Disable smooth scrolling (uncomment if you prefer instant scrolling)
        # "--disable-smooth-scrolling"

        # Enable experimental web platform features
        # "--enable-experimental-web-platform-features"
      ];
  };
  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs-unstable.brave}/bin/brave";
    # Point Chromium/Brave to NSS certificate database (same as Firefox)
    NSS_DEFAULT_DB_TYPE = "sql";
  };

  # Wrapper script to ensure Brave uses system certificates
  home.packages = [
    (pkgs.writeShellScriptBin "brave-with-certs" ''
      export NSS_DEFAULT_DB_TYPE="sql"
      exec ${pkgs-unstable.brave}/bin/brave "$@"
    '')
  ];
}
