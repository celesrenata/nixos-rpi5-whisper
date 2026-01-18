{ config, pkgs, lib, ... }:
{
  imports = [ ../../modules/satellite.nix ];

  services.wyoming.satellite = {
    name = "goblin-1-satellite";
    area = "bedroom";
  };
}
