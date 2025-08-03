{
    # Set an admin user: `sude paperless-manage createsuperuser`
    services = {

      paperless = {
        enable = true;
        consumptionDirIsPublic = true;
        settings = {
          PAPERLESS_CONSUMER_IGNORE_PATTERN = [
            ".DS_STORE/*"
            "desktop.ini"
          ];
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
          PAPERLESS_URL = "https://paperless.skarmux.tech";
        };
      };

      nginx = {
        enable = true;
        virtualHosts."paperless.skarmux.tech" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:28981/";
            recommendedProxySettings = true;
          };
        };
      };
    };
}