{ config, pkgs, lib, ... }:
{
  imports = [ ../../modules/satellite.nix ];

  services.wyoming.satellite = {
    name = "goblin-2-satellite";
    area = "living room";
  };
}
