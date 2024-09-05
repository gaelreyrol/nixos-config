{ inputs, pkgs, ... }:

{
  nix = {
    package = pkgs.unstable.nixVersions.nix_2_23;

    registry.nixpkgs.flake = inputs.nixpkgs;

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "unstable=${inputs.unstable.outPath}"
      "master=${inputs.master.outPath}"
    ];

    # https://jackson.dev/post/nix-reasonable-defaults/
    extraOptions = ''
      connect-timeout = 5
      log-lines = 25
      min-free = 128000000
      max-free = 1000000000
      experimental-features = nix-command flakes auto-allocate-uids
      fallback = true
      warn-dirty = false
      # keep-outputs = true
      # keep-derivations = true
      # plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
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
        "nixos"
      ];
      secret-key-files = "/var/nix/cache-priv-key.pem";
      trusted-public-keys = [
        "tower:vj89DUI6QATXfwiGzRGX8Y5FEtOWDQ4GUSscdc5e5vE="
        "thinkpad:IdGPnji32UUVFHffGtYW/0OdGJ0CBzqPw7cle/+zNec="
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };

  environment.systemPackages = with pkgs; [
    nix-init
    nix-update
    nixpkgs-review
    nixpkgs-fmt
    cachix
    nix-doc
    nixdoc
  ];
}
