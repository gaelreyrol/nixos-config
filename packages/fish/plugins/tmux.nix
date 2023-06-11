{ lib, fishPlugins, fetchFromGitHub, tmux }:

fishPlugins.buildFishPlugin rec {
  pname = "tmux.fish";
  version = "2023-02-09";

  src = fetchFromGitHub {
    owner = "budimanjojo";
    repo = pname;
    rev = "87ef5c238b7fb133d7b49988c7c3fcb097953bd2";
    sha256 = "sha256-ds1WN10Xlp6BYk1Wooq8NIkVyt5gJguKBH4JBrPo/Qo=";
  };

  checkInputs = [ tmux ];

  #buildFishplugin will only move the .fish files, but conf files are needed
  postInstall = ''
    cp conf.d/*.conf $out/share/fish/vendor_conf.d/
  '';

  meta = with lib; {
    description = "Tmux plugin for fish shell";
    homepage = "https://github.com/budimanjojo/tmux.fish";
    license = licenses.mit;
    maintainers = [ ];
    platforms = with platforms; unix;
  };
}
