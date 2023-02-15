{ sbomnix, ... }:

final: prev: {
  sbomnix = sbomnix.packages.${prev.system}.sbomnix;
}
