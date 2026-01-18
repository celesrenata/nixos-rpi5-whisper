{ config, pkgs, lib, ... }:
{
  imports = [ ../../modules/wyoming-fix.nix ];
  imports = [ ../../modules/satellite.nix ];

  services.wyoming.satellite = {
    name = "goblin-3-satellite";
    area = "office";
  };
}
