pkgs: superPkgs:

{
  myPkgs = {
    gnome-monitors-switch = pkgs.callPackage ./gnome-monitors-switch { };
    mqttx = pkgs.callPackage ./mqttx { inherit pkgs; };
  };
}
