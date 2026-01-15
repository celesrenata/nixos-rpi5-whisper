{ config, hardware, lib, pkgs, ... }:
{
  imports = [
    ./graphics.nix
    ./remote-build.nix
    ./whisper.nix
    ./dns.nix
  ];

  boot.kernelParams = [ "8250.nr_uarts=11" "console=ttyAMA10,115200" "console=tty0" "usbhid.mousepoll=0" ];
  boot.kernelModules = [ "uinput" ];
  zramSwap.enable = true;
  boot.supportedFilesystems = [ "ext4" "nfs" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  hardware.deviceTree = {
    enable = true;
    filter = "*rpi-5-*.dtb";
  };

  services.hardware.argonone.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "onDemand";
      turbo = "auto";
    };
    charger = {
      governor = "onDemand";
      turbo = "auto";
    };
  };
  
  systemd.services.fixFirmware = {
    enable = true;
    description = "Overwrite UEFI file, because it is unstable on devices with heavy load.";
    unitConfig.StopWhenUnneeded = "yes";
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStop = [ "cp /boot/RPI_EFI.fd.bak /boot/RPI_EFI.fd" ];
    };
    wantedBy = [ "multi-user.target" ];
  };

  networking = {
    useNetworkd = true;
    wireless.enable = true;
    wireless.networks."Aitheria".psk = "Wrttradim3nto$$";
    useDHCP = false;
    interfaces.eth0.useDHCP = lib.mkForce true;
    interfaces.wlan0.useDHCP = lib.mkForce true;
  };
  
  systemd.network.enable = true;
  systemd.network.networks."10-wlan0" = {
    matchConfig.Name = "wlan0";
    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = true;
    };
  };

  systemd.services.wpa_supplicant.wantedBy = lib.mkForce [ "multi-user.target" ];
  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    extraConfig.pipewire."92-gain.conf" = {
      "context.modules" = [{
        name = "libpipewire-module-filter-chain";
        args = {
          "node.name" = "mic-gain";
          "media.name" = "Mic Gain";
          "media.class" = "Audio/Source";
          "filter.graph".nodes = [{
            type = "ladspa";
            name = "amp-gain";
            plugin = "${pkgs.ladspaPlugins}/lib/ladspa/amp_1181.so";
            label = "amp";
            control."Amp Level" = 15.0;
          }];
        };
      }];
    };
  };

  nix.extraOptions = ''
    require-sigs = false
  '';
  time.timeZone = "America/Los_Angeles";

  sops = {
    defaultSopsFile = ./secrets.toml;
    age.keyFile = ./.age-key.txt;
  };
  
  environment.systemPackages = with pkgs; [
    vim wpa_supplicant curl git nmap btop usbutils pciutils
    waypipe screen nfs-utils alsa-utils pulsemixer unzip
  ];

  security.pki.certificateFiles = [ ./home.crt ];
  
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];
  
  users.users.celes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };
  users.users.arsham = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.groups.audio.members = [ "celes" "whisper" ];
  users.users.nixremote.isNormalUser = true;

  system.stateVersion = "25.05";
}
