{ config, pkgs, lib, inputs, ... }:
{
  # Use wyoming-satellite from unstable to get matching Wyoming protocol version
  services.wyoming.satellite.package = lib.mkForce inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.wyoming-satellite;
}
