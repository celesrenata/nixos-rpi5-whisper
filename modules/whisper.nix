{ config, pkgs, pkgs-unstable, lib, ... }:
{
  services.wyoming = {
    openwakeword = { 
      enable = true;
      package = pkgs.wyoming-openwakeword.override {
        python3Packages = pkgs.python3Packages // {
          pyopen-wakeword = pkgs.python3Packages.pyopen-wakeword.overrideAttrs (old: {
            doCheck = false;
            doInstallCheck = false;
          });
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 10500 ];
}
