{ ... }:
{
  nix.buildMachines = [
    {
      hostName = "goblin-1";
      systems = ["aarch64-linux"];
      protocol = "ssh-ng";
      maxJobs = 4;
      speedFactor = 1;
      supportedFeatures = [ "nixos-test" "big-parallel" "benchmark" "kvm" ];
    }
    {
      hostName = "goblin-2";
      systems = ["aarch64-linux"];
      protocol = "ssh-ng";
      maxJobs = 4;
      speedFactor = 1;
      supportedFeatures = [ "nixos-test" "big-parallel" "benchmark" "kvm" ];
    }
    {
      hostName = "goblin-3";
      systems = ["aarch64-linux"];
      protocol = "ssh-ng";
      maxJobs = 4;
      speedFactor = 1;
      supportedFeatures = [ "nixos-test" "big-parallel" "benchmark" "kvm" ];
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
