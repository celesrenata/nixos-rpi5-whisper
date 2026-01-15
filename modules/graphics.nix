{ config, lib, pkgs, nixpkgs, ... }:
{
  systemd.services.home-assistant.serviceConfig.DeviceAllow = ["/dev/dri/card0"];
  environment.systemPackages = [ pkgs.libGL ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ libva-vdpau-driver libvdpau-va-gl libGL ];
  };
  services.xserver.videoDrivers = [ "v3d" ];
}
