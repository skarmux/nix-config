# Home-Manager Modules

## Structure


### default.nix
Importing every file or directory within the same directory.
```
{ lib, ... }: with lib;
{
  imports = with builtins;
    map (fn: ./${fn})
      (filter
        (fn: (
          fn != "default.nix"
          && !hasSuffix ".md" "${fn}"
        ))
        (attrNames (readDir ./.)));
}
```
