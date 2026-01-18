{ config, pkgs, lib, ... }:
{
  environment.etc."openwakeword/models/nixberry.tflite" = {
    source = ./nixberry.tflite;
    mode = "0644";
  };

  services.wyoming.openwakeword = {
    customModelsDirectories = [ "/etc/openwakeword/models" ];
  };
}
