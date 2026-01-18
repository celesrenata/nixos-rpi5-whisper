{ config, pkgs, lib, ... }:
let
  wyoming-1-8-0 = pkgs.python3Packages.wyoming.overrideAttrs (old: rec {
    version = "1.8.0";
    src = pkgs.fetchPypi {
      pname = "wyoming";
      inherit version;
      sha256 = "sha256-kMFsn7fpDLzidwMoBreBbmxjGBI5MganMpj0rU/823Y=";
    };
  });
  
  satellite-with-new-wyoming = pkgs.wyoming-satellite.override {
    wyoming = wyoming-1-8-0;
  };
in
{
  services.wyoming.satellite.package = lib.mkForce satellite-with-new-wyoming;
}
