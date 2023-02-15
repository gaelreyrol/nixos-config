{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.apps.firefox;
  gnomeEnabled = config.gaelreyrol.desktop.gnome.enable;

  defaults = {
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      french-dictionary
      french-language-pack
      onepassword-password-manager
      facebook-container
      multi-account-containers
      decentraleyes
      clearurls
      ublock-origin
      consent-o-matic
      onetab
      gnome-shell-integration
      gsconnect
    ];
    bookmarks = [
      {
        name = "Add to bookmarks";
        url = "javascript:(function(){var a=window,b=document,c=encodeURIComponent,e=c(document.title),d=a.open('https://cloud.gaelreyrol.com/apps/bookmarks/bookmarklet?url='+c(b.location)+'&title='+e,'bkmk_popup','left='+((a.screenX||a.screenLeft)+10)+',top='+((a.screenY||a.screenTop)+10)+',height=650px,width=550px,resizable=1,alwaysRaised=1');a.setTimeout(function(){d.focus()},300);})();";
      }
      {
        name = "Home Manager";
        url = "https://rycee.gitlab.io/home-manager/options.html";
      }
    ];
    engines = {
      "Nix Packages" = {
        urls = [{
          template = "https://search.nixos.org/packages";
          params = [
            { name = "type"; value = "packages"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        definedAliases = [ "@np" ];
      };

      "Nix Options" = {
        urls = [{
          template = "https://search.nixos.org/options";
          params = [
            { name = "type"; value = "packages"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        definedAliases = [ "@no" ];
      };

      "NixOS Wiki" = {
        urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
        definedAliases = [ "@nw" ];
      };
    };
  };
in
{
  options.gaelreyrol.apps.firefox = with types; {
    enable = mkEnableOption "Whether or not to enable Firefox.";
    email = mkOption {
      type = str;
      default = config.gaelreyrol.user.name;
      description = "The email account to sync Firefox with.";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          enableGnomeExtensions = gnomeEnabled;
        };
      };
      profiles.default = {
        inherit (defaults) extensions;

        id = 0;

        # https://github.com/nix-community/home-manager/issues/3569
        # search.engines = defaults.engines;

        bookmarks = [
          {
            toolbar = true;
            inherit (defaults) bookmarks;
          }
        ];
        settings = import ./settings.nix { inherit lib cfg; };
      };
    };
  };
}
