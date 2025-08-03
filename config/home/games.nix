{ config, pkgs, ... }:
{
   home.packages = [
     (pkgs.writeShellScriptBin "clear-mhw-cache" ''
         rm --force /home/${config.home.username}/.steam/steam/steamapps/common/MonsterHunterWilds/{shader.cache2,vkd3d-proton.cache}
     '')
   ]; 
}