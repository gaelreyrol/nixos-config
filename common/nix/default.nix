{ config, lib, pkgs, nur, ... }:

{
  nix = {
    package = pkgs.unstable.nix;

    # https://jackson.dev/post/nix-reasonable-defaults/
    extraOptions = ''
      connect-timeout = 5
      log-lines = 25
      min-free = 128000000
      max-free = 1000000000
      experimental-features = nix-command flakes
      fallback = true
      warn-dirty = false
      # keep-outputs = true
      # keep-derivations = true
      plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
    '';

    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "gael"
        "lab"
        "router"
      ];
      secret-key-files = "/var/nix/cache-priv-key.pem";
      trusted-public-keys = [
        "tower:vj89DUI6QATXfwiGzRGX8Y5FEtOWDQ4GUSscdc5e5vE="
        "thinkpad:IdGPnji32UUVFHffGtYW/0OdGJ0CBzqPw7cle/+zNec="
        "mention:ldKF4a2iMpBMl4JqIUPF+hTw9H4ShBj4x3LFojj7dPg="
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };
}
