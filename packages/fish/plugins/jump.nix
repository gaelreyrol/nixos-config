{ lib, fishPlugins, fetchFromGitHub }:

fishPlugins.buildFishPlugin {
  pname = "jump";
  version = "unstable-2021-02-14";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-jump";
    rev = "af285ff91fa9d0d0261b810e09f8a4a05a6b1307";
    sha256 = "sha256-NQa12L0zlEz2EJjMDhWUhw5cz/zcFokjuCK5ZofTn+Q=";
  };

  postInstall = ''
    cp conf.d/executables $out/share/fish/vendor_conf.d/
  '';

  meta = with lib; {
    description = "A port of Jeroen Janssens' jump utility.";
    homepage = "https://github.com/oh-my-fish/plugin-jump";
    license = licenses.mit;
    maintainers = [ ];
    platforms = with platforms; unix;
  };
}
