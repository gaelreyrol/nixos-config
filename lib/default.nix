{ inputs, ... }:

{
  os = import ./os { inherit inputs; };
  user = import ./user { inherit inputs; };
}
