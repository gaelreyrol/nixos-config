{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.stateVersion = "22.05";

  imports = [
    ./dconf.nix
    ../../common/activation/home-report-changes.nix
  ];

  services.network-manager-applet.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    BAT_THEME = "Solarized (light)";
  };

  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubikey-manager-qt

    _1password
    _1password-gui

    keybase
    kbfs
    keybase-gui

    chromium

    slack
    discord
    zoom-us
    fractal
    element-desktop
    signal-desktop

    thunderbird
    vlc
    filezilla
    libreoffice
    spotify

    jetbrains-mono

    vscodium
    jetbrains.phpstorm
    insomnia
    postman

    shellcheck
    checkmake
    dhall
    dhall-json
    dhall-lsp-server

    exercism
  ];

  fonts.fontconfig.enable = true;

  services.keybase.enable = true;
  services.kbfs.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.enableFishIntegration = true;

  programs.vim.enable = true;

  programs.jq.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableGnomeExtensions = true;
      };
    };
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
    profiles.default = {
      id = 0;
      bookmarks = [
        {
          toolbar = true;
          bookmarks = [
            {
              name = "Add to bookmarks";
              url = "javascript:(function(){var a=window,b=document,c=encodeURIComponent,e=c(document.title),d=a.open('https://cloud.gaelreyrol.com/apps/bookmarks/bookmarklet?url='+c(b.location)+'&title='+e,'bkmk_popup','left='+((a.screenX||a.screenLeft)+10)+',top='+((a.screenY||a.screenTop)+10)+',height=650px,width=550px,resizable=1,alwaysRaised=1');a.setTimeout(function(){d.focus()},300);})();";
            }
            {
              name = "NixOS Packages";
              url = "https://search.nixos.org/packages";
            }
            {
              name = "NixOS Options";
              url = "https://search.nixos.org/options";
            }
            {
              name = "Home Manager";
              url = "https://rycee.gitlab.io/home-manager/options.html";
            }
            {
              name = "SensCritique - BD";
              url = "https://www.senscritique.com/bd";
            }
            {
              name = "Leslibrairies.fr";
              url = "https://www.leslibraires.fr";
            }
          ];
        }
      ];
      settings = {
        "services.sync.username" = "me@gaelreyrol.com";

        # https://github.com/arkenfox/user.js
        # Enable ETP for decent security (makes firefox containers and many
        # common security/privacy add-ons redundant).
        "browser.contentblocking.category" = "strict";
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = 1;
        "privacy.purge_trackers.enabled" = true;
        # Your customized toolbar settings are stored in
        # 'browser.uiCustomization.state'. This tells firefox to sync it between
        # machines. WARNING: This may not work across OSes. Since I use NixOS on
        # all the machines I use Firefox on, this is no concern to me.
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
        # Don't use the built-in password manager. A nixos user is more likely
        # using an external one (you are using one, right?).
        "signon.rememberSignons" = false;
        # Do not check if Firefox is the default browser
        "browser.shell.checkDefaultBrowser" = false;
        # Disable the "new tab page" feature and show a blank tab instead
        # https://wiki.mozilla.org/Privacy/Reviews/New_Tab
        # https://support.mozilla.org/en-US/kb/new-tab-page-show-hide-and-customize-top-sites#w_how-do-i-turn-the-new-tab-page-off
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";
        # Disable Activity Stream
        # https://wiki.mozilla.org/Firefox/Activity_Stream
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        # Disable new tab tile ads & preload
        # http://www.thewindowsclub.com/disable-remove-ad-tiles-from-firefox
        # http://forums.mozillazine.org/viewtopic.php?p=13876331#p13876331
        # https://wiki.mozilla.org/Tiles/Technical_Documentation#Ping
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-source
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-ping
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        # Reduce search engine noise in the urlbar's completion window. The
        # shortcuts and suggestions will still work, but Firefox won't clutter
        # its UI with reminders that they exist.
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        # https://bugzilla.mozilla.org/1642623
        "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
        # https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        # Show whole URL in address bar
        "browser.urlbar.trimURLs" = false;
        # Disable some not so useful functionality.
        "browser.disableResetPrompt" = true; # "Looks like you haven't started Firefox in a while."
        "browser.onboarding.enabled" = false; # "New to Firefox? Let's get started!" tour
        "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "reader.parse-on-load.enabled" = false; # "reader view"

        # Security-oriented defaults
        "security.family_safety.mode" = 0;
        # https://blog.mozilla.org/security/2016/10/18/phasing-out-sha-1-on-the-public-web/
        "security.pki.sha1_enforcement_level" = 1;
        # https://github.com/tlswg/tls13-spec/issues/1001
        "security.tls.enable_0rtt_data" = false;
        # Use Mozilla geolocation service instead of Google if given permission
        "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.provider.use_gpsd" = false;
        # https://support.mozilla.org/en-US/kb/extension-recommendations
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.getAddons.showPane" = false; # uses Google Analytics
        "browser.discovery.enabled" = false;
        # Reduce File IO / SSD abuse
        # Otherwise, Firefox bombards the HD with writes. Not so nice for SSDs.
        # This forces it to write every 30 minutes, rather than 15 seconds.
        "browser.sessionstore.interval" = "1800000";
        # Disable battery API
        # https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
        "dom.battery.enabled" = false;
        # Disable "beacon" asynchronous HTTP transfers (used for analytics)
        # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
        "beacon.enabled" = false;
        # Disable pinging URIs specified in HTML <a> ping= attributes
        # http://kb.mozillazine.org/Browser.send_pings
        "browser.send_pings" = false;
        # Disable gamepad API to prevent USB device enumeration
        # https://www.w3.org/TR/gamepad/
        # https://trac.torproject.org/projects/tor/ticket/13023
        "dom.gamepad.enabled" = false;
        # Don't try to guess domain names when entering an invalid domain name in URL bar
        # http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
        "browser.fixup.alternate.enabled" = false;
        # Disable telemetry
        # https://wiki.mozilla.org/Platform/Features/Telemetry
        # https://wiki.mozilla.org/Privacy/Reviews/Telemetry
        # https://wiki.mozilla.org/Telemetry
        # https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
        # https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
        # https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
        # https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
        # https://wiki.mozilla.org/Telemetry/Experiments
        # https://support.mozilla.org/en-US/questions/1197144
        # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.ping-centre.telemetry" = false;
        # https://mozilla.github.io/normandy/
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;
        # Disable health reports (basically more telemetry)
        # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
        # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;

        # Disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # don't submit backlogged reports

        # Disable Form autofill
        # https://wiki.mozilla.org/Firefox/Features/Form_Autofill
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      # "github.com" = {
      #   extraOptions = {
      #     https://1password.community/discussion/121912/keyring-isnt-suid-on-nixos
      #     IdentityAgent = "~/.1password/agent.sock";
      #   };
      # };
      "dev.gael.office" = {
        user = "gael";
        identityFile = "~/.ssh/recisio";
        forwardAgent = true;
        extraOptions = {
          RequestTTY = "yes";
          RemoteCommand = "tmux new -A -s default";
        };
      };

    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "JetBrains Mono";
        size = 12.0;
      };

      colors = {
        primary = {
          background = "#fdf6e3";
          foreground = "#657b83";
        };
        cursor = {
          text = "#fdf6e3";
          curser = "#657b83";
        };
        normal = {
          black = "#073642";
          red = "#dc322f";
          green = "#859900";
          yellow = "#b58900";
          blue = "#268bd2";
          magenta = "#d33682";
          cyan = "#2aa198";
          white = "#eee8d5";
        };
        bright = {
          black = "#002b36";
          red = "#cb4b16";
          green = "#586e75";
          yellow = "#657b83";
          blue = "#839496";
          magenta = "#6c71c4";
          cyan = "#93a1a1";
          white = "#fdf6e3";
        };
      };
    };
  };

  programs.fish = {
    enable = true;
    functions =
      {
        fish_greeting = "";
      };
    shellAliases = {
      pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
      pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
      code = "${pkgs.vscodium}/bin/codium";
      dig = "dog";
      ls = "exa";
      cat = "bat";
      office = "${pkgs.openssh}/bin/ssh dev.gael.office";
    };
    interactiveShellInit = ''
      if status is-interactive
      and not set -q TMUX
        tmux new-session -A -s default
      end
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.git = {
    enable = true;
    userName = "Gaël Reyrol";
    userEmail = "me@gaelreyrol.dev";
    signing = {
      key = "DFB9B69A2C427F61";
      signByDefault = true;
    };
    includes = [
      {
        condition = "gitdir:/home/gael/dev/recisio/";
        contents = {
          user = {
            email = "gael@recisio.com";
            name = "Gaël Reyrol";
            signingKey = "273123EAC37D2A99";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      fetch.prune = true;
      diff.colorMoved = "default";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.tmux-fzf
    ];
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "solarized-light";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    # https://github.com/nix-community/home-manager/issues/2798
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      editorconfig.editorconfig
      # vscode-icons-team.vscode-icons
      jnoortheen.nix-ide
      octref.vetur
      foam.foam-vscode
      yzhang.markdown-all-in-one
      # kortina.vscode-markdown-notes
      # mushan.vscode-paste-image
      hashicorp.terraform
      redhat.vscode-yaml
      # redhat.ansible
      timonwong.shellcheck
      gruntfuggly.todo-tree
      dhall.vscode-dhall-lsp-server
    ];
    userSettings = {
      "workbench.colorTheme" = "Solarized Light";
      "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontSize" = 16;
      "nix.enableLanguageServer" = true;
    };
  };
}
