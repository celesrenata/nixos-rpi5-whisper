{ config, lib, pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  services.resolved = {
    enable = true;
    domains = [ "celestium.life" "~." ];
    fallbackDns = [ "192.168.42.1" "1.1.1.1" "8.8.8.8" ];
    extraConfig = ''
      DNS=192.168.42.1
      Domains=celestium.life
      MulticastDNS=yes
      LLMNR=yes
    '';
  };
}
