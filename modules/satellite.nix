{ config, pkgs, lib, ... }:
let
  pw-record-wrapper = pkgs.writeShellScript "pw-record-wrapper" ''
    export XDG_RUNTIME_DIR=/run/satellite
    exec ${pkgs.pipewire}/bin/pw-record "$@"
  '';
  pw-play-wrapper = pkgs.writeShellScript "pw-play-wrapper" ''
    export XDG_RUNTIME_DIR=/run/satellite
    exec ${pkgs.pipewire}/bin/pw-play "$@"
  '';
in
{
  users.users.satellite = {
    isSystemUser = true;
    group = "satellite";
    extraGroups = [ "audio" ];
    home = "/var/lib/satellite";
    createHome = true;
  };
  users.groups.satellite = {};

  environment.etc."satellite/sounds/awake.wav" = {
    source = ./nixberry_awake.wav;
    mode = "0644";
  };

  environment.etc."satellite/sounds/done.wav" = {
    source = ./nixberry_done.wav;
    mode = "0644";
  };

  systemd.services.pipewire-satellite = {
    description = "PipeWire for Satellite";
    wantedBy = [ "multi-user.target" ];
    after = [ "sound.target" ];
    before = [ "wyoming-satellite.service" ];
    environment = {
      XDG_RUNTIME_DIR = "/run/satellite";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.pipewire}/bin/pipewire -c ${pkgs.pipewire}/share/pipewire/pipewire.conf";
      Restart = "on-failure";
      User = "satellite";
      Group = "satellite";
      SupplementaryGroups = [ "audio" ];
      RuntimeDirectory = "satellite";
      StateDirectory = "satellite";
    };
  };

  systemd.services.wireplumber-satellite = {
    description = "WirePlumber for Satellite";
    wantedBy = [ "multi-user.target" ];
    after = [ "pipewire-satellite.service" ];
    before = [ "wyoming-satellite.service" ];
    environment = {
      XDG_RUNTIME_DIR = "/run/satellite";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.wireplumber}/bin/wireplumber";
      Restart = "on-failure";
      User = "satellite";
      Group = "satellite";
      SupplementaryGroups = [ "audio" ];
    };
  };

  systemd.services.wyoming-satellite.after = [ "wireplumber-satellite.service" ];
  systemd.services.wyoming-satellite.environment = {
    XDG_RUNTIME_DIR = "/run/satellite";
  };

  services.wyoming.satellite = {
    enable = true;
    user = "satellite";
    group = "satellite";
    uri = "tcp://0.0.0.0:10500";
    microphone = {
      command = "${pw-record-wrapper} --rate 16000 --channels 1 --format s16 -";
      autoGain = 5;
    };
    sound.command = "${pw-play-wrapper} --rate 22050 --channels 1 --format s16 -";
    sounds = {
      awake = "/etc/satellite/sounds/awake.wav";
      done = "/etc/satellite/sounds/done.wav";
    };
    vad.enable = true;
    extraArgs = [
      "--wake-uri" "tcp://127.0.0.1:10400"
      "--wake-word-name" "nixberry"
      "--snd-uri" "tcp://127.0.0.1:10300"
      "--debug"
    ];
  };
}
