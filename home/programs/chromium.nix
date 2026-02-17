{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
# Stock Chromium configuration
# https://stackoverflow.com/questions/8946325/chrome-extension-id-how-to-find-it
{
  # Install Chromium package directly
  home.packages = with pkgs; [
    chromium
  ];

  # Create wrapper script for Chromium with custom flags and certificate support
  home.file.".local/bin/chromium-custom" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      export NSS_DEFAULT_DB_TYPE="sql"
      
      exec ${pkgs.chromium}/bin/chromium \
        --use-system-default-cert-store \
        --disable-background-networking \
        --disable-breakpad \
        --disable-crash-reporter \
        --disable-sync \
        --disable-domain-reliability \
        --ozone-platform=wayland \
        --enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder,HttpsOnlyMode \
        --disable-features=UseChromeOSDirectVideoDecoder,MediaRouter \
        --enable-zero-copy \
        --disable-gpu-compositing \
        --force-dark-mode \
        "$@"
    '';
  };
}
