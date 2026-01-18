{ config, pkgs, lib, ... }:
{
  environment.etc."openwakeword/models/nixberry.onnx" = {
    source = ./nixberry.onnx;
    mode = "0644";
  };

  services.wyoming.openwakeword = {
    customModelsDirectories = [ "/etc/openwakeword/models" ];
  };
}
