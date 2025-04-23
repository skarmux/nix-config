# https://yazi-rs.github.io/docs/configuration/yazi/
{ config, lib, pkgs, ... }:
{
  programs.yazi = {

    shellWrapperName = "y";

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    settings = {
      manager = {
        ratio = [ 0 1 3 ];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
        scrolloff = 8;
        title_format = "";
      };
      preview = {
        wrap = "no";
        tab_size = 4;
        image_filter = "nearest";
        image_quality = 50; # 50-90
      };
      opener = {
        # Configure available openers that  can be used in `[open]`
        # $0 - The hovered file.
        # $n - The N-th selected file.
        # $@ - All selected files.
        edit = [
          { run = "\${EDITOR:-vi} \"$@\""; desc = "$EDITOR"; block = true; for = "unix"; }
        ];
        open = [
          { run = "xdg-open \"$1\""; desc = "Open"; for = "linux"; }
          { run = "open \"$@\""; desc = "Open"; for = "macos"; }
        ];
        # Open location in desktop file-browser or similar
        reveal = [
          { run = "xdg-open \"$(dirname \"$1\")\""; desc = "Reveal"; for = "linux"; }
          { run = "open -R \"$1\""; desc = "Reveal"; for = "macos"; }
        ];
        extract = [
          { run = "ya pub extract --list \"$@\""; desc = "Extract here"; for = "unix"; }
        ];
        play = [
          { run = "celluloid --new-window \"$@\""; orphan = true; for = "linux"; }
          { run = "mpv --force-window \"$@\""; orphan = true; for = "unix"; }
        ];
        bulk-rename = [
          { run = "$EDITOR \"$@\""; block = true; for = "unix"; }
        ];
      };
      open = {
        prepend_rules = [
          { name = "bulk-rename.txt"; use = "bulk-rename"; }
        ];
        rules = [
          # Folder
          { name = "*/"; use = [ "edit" "open" "reveal" ]; }
          # Text
          { mime = "text/*"; use = [ "edit" "reveal" ]; }
          # Image
          { mime = "image/*"; use = [ "open" "reveal" ]; }
          # Media
          { mime = "{audio;video}/*"; use = [ "play" "reveal" ]; }
          # Archive
          { mime = "application/{zip;rar;7z*;tar;gzip;xz;zstd;bzip*;lzma;compress;archive;cpio;arj;xar;ms-cab*}"; use = [ "extract" "reveal" ]; }
          # JSON
          { mime = "application/{json;ndjson}"; use = [ "edit" "reveal" ]; }
          { mime = "*/javascript"; use = [ "edit" "reveal" ]; }
          # Empty file
          { mime = "inode/empty"; use = [ "edit" "reveal" ]; }
          # Fallback
          { name = "*"; use = [ "open" "reveal" ]; }
        ];
        append_rules = [ ];
      };
    };
  };
}
