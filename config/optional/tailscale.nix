{ pkgs, lib, ... }:
# First time register:
# $ sudo tailscale up --auth-key=KEY
#
# Route port 22 through tailnet:
# $ sudo tailscale up --ssh
#
# TODO: How do I connect to multiple tailnets?
# Minecraft Linz:
# $ tailscale up \
#   --accept-routes \
#   --operator=aNameIfyouWannaRunAsNonRoot \
#   --auth-key=tskey-auth-keKX3jh3pS11CNTRL-7NNRypkqEeccPadJ8kJBecchK3ntcHx15
# let
#   minecraft-linz = pkgs.writeShellApplication {
#     name = "minecraft-linz";
#     text = ''
#       STATE_DIRECTORY=/var/lib/tailscale-minecraft-linz
#       mkdir -p $STATE_DIRECTORY
#       env STATE_DIRECTORY=$STATE_DIRECTORY tailscaled --statedir=$STATE_DIRECTORY --socket=$STATE_DIRECTORY/tailscaled.sock --port=0 --tun=user
#       tailscale \
#         --socket=$STATE_DIRECTORY/tailscaled.sock up \
#         --auth-key=tskey-key-MYSERVICE_KEY_FROM_TAILSCALE_ADMIN_CONSOLE \
#         --hostname=MYSERVICE \
#         --reset
#     '';
#   };
# in
{
  # $ STATE_DIRECTORY=/var/lib/tailscale/tailscaled-tt_rss
  # $ sudo mkdir -p ${STATE_DIRECTORY}
  # $ sudo env STATE_DIRECTORY=${STATE_DIRECTORY} tailscaled --statedir=${STATE_DIRECTORY} --socket=${STATE_DIRECTORY}/tailscaled.sock --port=0 --tun=user
  # $ sudo tailscale --socket=${STATE_DIRECTORY}/tailscaled.sock up --auth-key=tskey-key-MYSERVICE_KEY_FROM_TAILSCALE_ADMIN_CONSOLE --hostname=MYSERVICE --reset
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client"; # client | server | both
  };
}