{ config, pkgs, pkgs-unstable, lib, ... }:
{
  services.wyoming.openwakeword.enable = true;

  networking.firewall.allowedTCPPorts = [ 10500 ];
}
