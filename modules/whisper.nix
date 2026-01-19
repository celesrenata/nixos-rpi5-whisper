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
    faster-whisper.package = pkgs-unstable.wyoming-faster-whisper;
    faster-whisper.servers."gremlin-1" = {
      enable = true;
      device = "cpu";
      model = "Systran/faster-whisper-tiny.en";
      language = "en";
      beamSize = 4;
      uri = "tcp://0.0.0.0:10300";
    };
    piper.servers."en" = {
      enable = true;
      voice = "en_US-lessac-medium";
      uri = "tcp://0.0.0.0:10200";
    };
  };

  networking.firewall.allowedTCPPorts = [ 10200 10300 10500 ];
}
