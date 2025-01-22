{ config, pkgs, ... }:

{
  imports = [
    ./dconf.nix
    ./memex
    ./nix
    ../../mixins/activation/home-report-changes.nix
  ];

  home = {
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "vim";
      BAT_THEME = "Solarized (light)";
    };
    packages = with pkgs; [
      yubikey-personalization
      yubikey-manager
      yubikey-manager-qt
      yubioath-flutter

      _1password-cli
      _1password-gui

      keybase

      chromium

      slack
      discord
      element-desktop
      signal-desktop

      thunderbird
      vlc
      filezilla
      libreoffice
      spotify

      jetbrains-mono

      vscodium
      # https://nixos.wiki/wiki/Jetbrains_Tools
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
      (unstable.jetbrains.plugins.addPlugins unstable.jetbrains.phpstorm [
        "symfony-support"
        "php-annotations"
        "nixidea"
        "csv-editor"
      ])
      insomnia
      # postman
      zeal

      nil # Nix LSP
      shellcheck
      checkmake
      dhall
      dhall-json
      dhall-lsp-server
      myPkgs.gh-diff-pr
      nix-output-monitor

      exercism
      darktable
    ];
  };

  fonts.fontconfig.enable = true;

  services = {
    keybase.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableFishIntegration = true;
      extraConfig = ''
        allow-loopback-pinentry
      '';
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  programs = {
    home-manager.enable = true;

    gpg.enable = true;

    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          enableGnomeExtensions = true;
        };
      };
      profiles.default = {
        id = 0;
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
          streetpass-for-mastodon
          sidebery
        ];
        search = {
          default = "Google";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
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
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            "Nix Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };

            "Nix Manual" = {
              urls = [{ template = "https://nixos.org/manual/nix/stable/introduction.html?search={searchTerms}"; }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nm" ];
            };

            "PHP Documentation" = {
              urls = [{ template = "https://www.php.net/manual-lookup.php?pattern={searchTerms}"; }];
              definedAliases = [ "@pd" ];
            };

            "PHP Packagist" = {
              urls = [{ template = "https://packagist.org/?query={searchTerms}"; }];
              definedAliases = [ "@pp" ];
            };

            "Symfony Documentation" = {
              urls = [{ template = "https://symfony.com/doc/current/index.html?query={searchTerms}"; }];
              definedAliases = [ "@sd" ];
            };
          };
        };
        bookmarks = [
          {
            toolbar = true;
            bookmarks = [
              {
                name = "Add to bookmarks";
                url = "javascript:(function(){var a=window,b=document,c=encodeURIComponent,e=c(document.title),d=a.open('https://cloud.gaelreyrol.com/apps/bookmarks/bookmarklet?url='+c(b.location)+'&title='+e,'bkmk_popup','left='+((a.screenX||a.screenLeft)+10)+',top='+((a.screenY||a.screenTop)+10)+',height=650px,width=550px,resizable=1,alwaysRaised=1');a.setTimeout(function(){d.focus()},300);})();";
              }
              {
                name = "Nix Manual";
                url = "https://nixos.org/manual/nix/stable/index.html";
              }
              {
                name = "Nixpkgs Manual";
                url = "https://nixos.org/manual/nixpkgs/stable/index.html";
              }
              {
                name = "NixOS Manual";
                url = "https://nixos.org/manual/nixos/stable/index.html";
              }
              {
                name = "Home Manager Manual";
                url = "https://nix-community.github.io/home-manager/options.xhtml";
              }
              {
                name = "Nix & Nixpkgs Functions";
                url = "https://teu5us.github.io/nix-lib.html";
              }
              {
                name = "Noogle";
                url = "https://noogle.dev/";
              }
              {
                name = "Nix package versions";
                url = "https://lazamar.co.uk/nix-versions/";
              }
              {
                name = "Nixpkgs Pull Request Tracker";
                url = "https://nixpk.gs/pr-tracker.html";
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

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        editorconfig.editorconfig
        jnoortheen.nix-ide
        octref.vetur
        foam.foam-vscode
        yzhang.markdown-all-in-one
        ## TODO: Package extension kortina.vscode-markdown-notes
        hashicorp.terraform
        redhat.vscode-yaml

        timonwong.shellcheck
        gruntfuggly.todo-tree
        dhall.vscode-dhall-lsp-server
        bungcip.better-toml
        dhall.dhall-lang
        golang.go
        redhat.java
      ];
      userSettings = {
        "redhat.telemetry.enabled" = false;
        "workbench.colorTheme" = "Solarized Light";
        "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontSize" = 16;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "nixpkgs-fmt";
        "vscode-dhall-lsp-server.executable" = "dhall-lsp-server";
        "window.zoomLevel" = 1;
      };
    };

    zellij = {
      enable = true;
      settings = {
        theme = "solarized-light";
      };
    };

    alacritty = {
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
            cursor = "#657b83";
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

    vim = {
      enable = true;
      plugins = [ pkgs.vimPlugins.vim-nix ];
      extraConfig = ''
        syntax on
        set number
      '';
    };

    jq.enable = true;
    htop.enable = true;
    btop.enable = true;

    ssh = {
      enable = true;
      matchBlocks = {
        # "github.com" = {
        #   extraOptions = {
        #     https://1password.community/discussion/121912/keyring-isnt-suid-on-nixos
        #     IdentityAgent = "~/.1password/agent.sock";
        #   };
        # };
      };
    };

    fish = {
      enable = true;
      plugins = [
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair-fish) src;
        }
        {
          name = "tmux";
          inherit (pkgs.fishPlugins.tmux) src;
        }
        {
          name = "jump";
          inherit (pkgs.fishPlugins.jump) src;
        }
      ];
      functions =
        {
          fish_greeting = "";
          phpEnv = ''
            function phpEnv --description 'start a nix-shell with the given PHP packages' --argument phpVersion
              if set -q argv[2]
                set argv $argv[2..-1]
              end

              for el in $argv
                set ppkgs $ppkgs "php"$phpVersion"Packages.$el"
              end

              nix-shell -p $ppkgs
            end
          '';
        };
      shellAliases = {
        pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
        pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
        code = "${pkgs.vscodium}/bin/codium";
        dig = "dog";
        ls = "eza";
        cat = "bat";
        grep = "rg";
        man = "batman";
        du = "dust";
        df = "duf -theme=light";
        find = "fd";
        tree = "broot";
        ps = "procs --theme light";
        j = "jump";
      };
      shellInit = ''
        set -Ux fish_tmux_config $HOME/.config/tmux/tmux.conf
        set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'" # https://wiki.archlinux.org/title/Color_output_in_console#Using_bat
      '';
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = false;
    };

    git = {
      enable = true;
      userName = "Gaël Reyrol";
      userEmail = "me@gaelreyrol.dev";
      lfs.enable = true;
      signing = {
        key = "DFB9B69A2C427F61";
        signByDefault = true;
      };
      delta.enable = true;
      includes = [
        {
          condition = "gitdir:/home/gael/Development/Kiosc/";
          contents = {
            core = {
              excludesFile = "/home/gael/Development/Kiosc/.gitignore";
            };
            user = {
              email = "greyrol@kiosc.com";
              name = "Gaël Reyrol";
              signingKey = "5D37286F3B2E505A";
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
        push.autoSetupRemote = true;
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
    };

    tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.tmux-fzf
      ];
      prefix = "M-w";
      extraConfig = ''
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        set -g status-right '%a %d-%m-%Y %H:%M'
        set-option -g renumber-windows on
      '';
    };

    broot = {
      enable = true;
      enableFishIntegration = true;
      # settings = {
      # imports = [
      #   {
      #     file = "solarized-dark.hjson";
      #     luma = ["dark" "unknown"];
      #   }
      #   {
      #     file = "solarized-light.hjson";
      #     luma = "light";
      #   }
      # ];
      # https://github.com/Canop/broot/blob/main/resources/default-conf/solarized-light.hjson
      # skin = {
      #   default = "rgb(101, 123, 131) rgb(253, 246, 227) / rgb(147, 161, 161) rgb(238, 232, 213)";
      #   tree = "rgb(147, 161, 161) none";
      #   file = "none none";
      #   directory = "rgb(38, 139, 210) none bold";
      #   exe = "rgb(211, 1, 2) none";
      #   link = "rgb(211, 54, 130) none";
      #   pruning = "rgb(147, 161, 161) none italic";
      #   perm__ = "rgb(147, 161, 161) none";
      #   perm_r = "none none";
      #   perm_w = "none none";
      #   perm_x = "none none";
      #   owner = "rgb(147, 161, 161) none";
      #   group = "rgb(147, 161, 161) none";
      #   sparse = "none none";
      #   git_branch = "rgb(88, 110, 117) none";
      #   git_insertions = "rgb(133, 153, 0) none";
      #   git_deletions = "rgb(211, 1, 2) none";
      #   git_status_current = "none none";
      #   git_status_modified = "rgb(181, 137, 0) none";
      #   git_status_new = "rgb(133, 153, 0) none";
      #   git_status_ignored = "rgb(147, 161, 161) none";
      #   git_status_conflicted = "rgb(211, 1, 2) none";
      #   git_status_other = "rgb(211, 1, 2) none";
      #   selected_line = "none rgb(238, 232, 213)";
      #   char_match = "rgb(133, 153, 0) none underlined";
      #   file_error = "rgb(203, 75, 22) none italic";
      #   flag_label = "none none";
      #   flag_value = "rgb(181, 137, 0) none bold";
      #   input = "none none";
      #   status_error = "rgb(203, 75, 22) rgb(238, 232, 213)";
      #   status_job = "rgb(108, 113, 196) rgb(238, 232, 213) bold";
      #   status_normal = "none rgb(238, 232, 213)";
      #   status_italic = "rgb(181, 137, 0) rgb(238, 232, 213)";
      #   status_bold = "rgb(88, 110, 117) rgb(238, 232, 213) bold";
      #   status_code = "rgb(108, 113, 196) rgb(238, 232, 213)";
      #   status_ellipsis = "none rgb(238, 232, 213)";
      #   scrollbar_track = "rgb(238, 232, 213) none";
      #   scrollbar_thumb = "none none";
      #   help_paragraph = "none none";
      #   help_bold = "rgb(88, 110, 117) none bold";
      #   help_italic = "rgb(88, 110, 117) none italic";
      #   help_code = "rgb(88, 110, 117) rgb(238, 232, 213)";
      #   help_headers = "rgb(181, 137, 0) none";
      #   help_table_border = "none none";
      #   preview_title = "rgb(147, 161, 161) rgb(238, 232, 213)";
      #   preview = "rgb(101, 123, 131) rgb(253, 246, 227) / rgb(147, 161, 161) rgb(238, 232, 213)";
      #   preview_line_number = "rgb(147, 161, 161) rgb(238, 232, 213)";
      #   preview_match = "None ansi(29)";
      #   staging_area_title = "gray(22) rgb(253, 246, 227)";
      #   good_to_bad_0 = "ansi(28)";
      #   good_to_bad_1 = "ansi(29)";
      #   good_to_bad_2 = "ansi(29)";
      #   good_to_bad_3 = "ansi(29)";
      #   good_to_bad_4 = "ansi(29)";
      #   good_to_bad_5 = "ansi(100)";
      #   good_to_bad_6 = "ansi(136)";
      #   good_to_bad_7 = "ansi(172)";
      #   good_to_bad_8 = "ansi(166)";
      #   good_to_bad_9 = "ansi(196)";
      # };
      # };
    };
  };
}
