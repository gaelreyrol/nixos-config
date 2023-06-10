{ self, super }:

{
  # https://github.com/NixOS/nixpkgs/pull/234880
  python3 = super.python3.override {
    packageOverrides = pself: psuper: {
      aiohttp = psuper.aiohttp.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [
          (super.fetchpatch {
            url = "https://github.com/aio-libs/aiohttp/commit/7dcc235cafe0c4521bbbf92f76aecc82fee33e8b.patch";
            hash = "sha256-ZzhlE50bmA+e2XX2RH1FuWQHZIAa6Dk/hZjxPoX5t4g=";
          })
        ];
      });
      uvloop = psuper.uvloop.overrideAttrs (oldAttrs: {
        disabledTestPaths = oldAttrs.disabledTestPaths ++ [
          "tests/test_regr1.py"
        ];
      });
      yarl = psuper.yarl.overrideAttrs (oldAttrs: rec {
        version = "1.9.2";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-BKudS59YfAbYAcKr/pMXt3zfmWxlqQ1ehOzEUBCCNXE=";
        };
        disabledTests = [ ];
      });
    };
  };

  fishPlugins = super.fishPlugins.overrideScope' (fself: fsuper: {
    tmux = super.callPackage ../../packages/fish/plugins/tmux.nix { };
  });
}
