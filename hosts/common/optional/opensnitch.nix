{ lib, pkgs, ... }: {
  services.opensnitch = {
    enable = true;
    rules = {

      # whitelist entirety of firefox web access
      firefox = {
        name = "firefox";
        enabled = true;
        precedence = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${pkgs.firefox}/bin/.firefox-wrapped --name firefox";
        };
      };

      # systemd-timesyncd is a daemon that has been added for
      # synchronizing the system clock across the network.
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
        precedence = false;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
        };
      };

      # systemd-resolved is a systemd service that provides network name 
      # resolution to local applications via a D-Bus interface, the resolve 
      # NSS service (nss-resolve(8)), and a local DNS stub listener on 127.0.0.53.
      systemd-resolved = {
        name = "systemd-resolved";
        enabled = true;
        precedence = false;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
        };
      };

      # Don't allow connections opened by binaries located under certain directories:
      # /dev/shm, /tmp, /var/tmp
      #
      # Why? If someone gets access to your system, usually these directories are 
      # the only ones where they can write files, thus it's usually used to drop malicious 
      # files, that download remote binaries to escalate privileges, etc.
      executables-tmp = {
        name = "executables-tmp";
        enabled = true;
        precedence = false;
        action = "deny";
        duration = "always";
        operator = {
          type = "regexp";
          sensitive = false;
          operand = "process.path";
          data = "/tmp/.*";
        };
      };

    };
  };

}
