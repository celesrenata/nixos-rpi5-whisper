{ config, pkgs, lib, ... }:
{
  imports = [ 
    ../../modules/satellite.nix 
    ../../modules/wyoming-fix.nix
  ];

  services.wyoming.satellite = {
    name = "goblin-3-satellite";
    area = "office";
  };
}
