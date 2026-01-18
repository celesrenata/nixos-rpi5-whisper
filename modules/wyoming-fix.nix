{ config, pkgs, lib, ... }:
{
  nixpkgs.overlays = [(self: super: {
    wyoming-satellite = super.python3Packages.buildPythonApplication rec {
      pname = "wyoming-satellite";
      version = "1.4.1";
      pyproject = true;

      src = super.fetchFromGitHub {
        owner = "rhasspy";
        repo = "wyoming-satellite";
        rev = "v${version}";
        hash = "sha256-w/s2Vgiz2qfczFwlJQaT+IvbvOt+Fy/VufQxgpqUxKg=";
      };

      build-system = with super.python3Packages; [ setuptools ];

      propagatedBuildInputs = with super.python3Packages; [
        pyring-buffer
        wyoming
        zeroconf
      ];

      pythonImportsCheck = [ "wyoming_satellite" ];
      dontCheckRuntimeDeps = true;
      pythonCatchConflicts = false;
    };
  })];
}
