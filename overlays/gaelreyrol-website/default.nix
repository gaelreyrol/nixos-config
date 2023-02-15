{ gaelreyrol-website, ... }:

final: prev: {
  gaelreyrol-website = gaelreyrol-website.packages.${prev.system}.website;
}
