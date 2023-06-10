{ self, super }:

{
  myPkgs = import ../../packages { inherit self super; };
}
