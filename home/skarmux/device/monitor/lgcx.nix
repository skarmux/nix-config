{
  # LG Electronics LG TV SSCR2 0x01010101
  monitors = [
    {
      name = "HDMI-A-1";
      width = 3840;
      height = 2160;
      refreshRate = 60;
      x = 0;
      vrr = true;
      hdr = true;
      workspace_padding = { top = 700; };

      # TODO: Declare in <host>.nix
      # Only use with ignika.nix for now!
      workspace = "1";
      primary = true;
    }
  ];
}
