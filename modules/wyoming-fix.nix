{ config, pkgs, lib, ... }:
let
  wyoming-1-8-0 = pkgs.python3Packages.buildPythonPackage rec {
    pname = "wyoming";
    version = "1.8.0";
    format = "setuptools";
    
    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-kMFsn7fpDLzidwMoBreBbmxjGBI5MganMpj0rU/823Y=";
    };
  };
in
{
  services.wyoming.satellite.package = pkgs.wyoming-satellite.overridePythonAttrs (old: {
    propagatedBuildInputs = builtins.filter (p: p.pname or "" != "wyoming") (old.propagatedBuildInputs or []) ++ [ wyoming-1-8-0 ];
  });
}
