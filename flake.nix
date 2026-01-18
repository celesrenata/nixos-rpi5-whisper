{
  description = "NixOS configuration for goblin cluster";

  inputs = {
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [ "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=" ];
  };

  outputs = inputs@{ nixos-raspberrypi, nixpkgs, nixpkgs-unstable, sops-nix, home-manager, ... }:
  let
    system = "aarch64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    
    makeGoblin = hostName: nixos-raspberrypi.lib.nixosSystem {
      specialArgs = { 
        inherit nixos-raspberrypi pkgs-unstable;
      };
      
      modules = [
        {
          imports = with nixos-raspberrypi.nixosModules; [
            raspberry-pi-5.base
            raspberry-pi-5.page-size-16k
          ];
          boot.loader.raspberryPi.bootloader = "kernel";
          networking.hostName = hostName;
          nixpkgs.overlays = [
            (final: prev: {
              python3 = prev.python3.override {
                packageOverrides = pyfinal: pyprev: {
                  wyoming = pyprev.wyoming.overridePythonAttrs (old: {
                    version = "1.7.2";
                    pyproject = true;
                    src = prev.fetchPypi {
                      pname = "wyoming";
                      version = "1.7.2";
                      hash = "sha256-PwYwyvsD6H3uhXu8r8Dk1zsyheyZ/pnh56jjy6buN5M=";
                    };
                    build-system = [ pyprev.setuptools ];
                  });
                  pyopen-wakeword = pyprev.pyopen-wakeword.overrideAttrs (old: {
                    doCheck = false;
                  });
                };
              };
              python3Packages = final.python3.pkgs;
            })
          ];
        }
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        ./modules/common.nix
        ./hosts/${hostName}/hardware-configuration.nix
      ];
    };
  in
  {
    nixosConfigurations = {
      goblin-1 = makeGoblin "goblin-1";
      goblin-2 = makeGoblin "goblin-2";
      goblin-3 = makeGoblin "goblin-3";
    };
  };
}
