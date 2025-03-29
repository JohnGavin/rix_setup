# This file was generated by the {rix} R package v0.15.5 on 2025-03-29
# with following call:
# >rix(date = "2025-03-03",
#  > r_pkgs = r_pkgs,
#  > system_pkgs = system_pkgs,
#  > git_pkgs = git_pkgs,
#  > tex_pkgs = NULL,
#  > ide = c("positron",
#  > "rstudio")[1],
#  > project_path = ".",
#  > overwrite = TRUE,
#  > shell_hook = shell_hook,
#  > r_ver = "4.4.3")
# It uses the `rstats-on-nix` fork of `nixpkgs` which provides improved
# compatibility with older R versions and R packages for Linux/WSL and
# Apple Silicon computers.
# Report any issues to https://github.com/ropensci/rix
let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/2025-03-03.tar.gz") { config.allowUnfree = true; };
 
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      brms
      bslib
      checkglobals
      data_table
      devtools
      DiagrammeR
      dplyr
      ellmer
      ggplot2
      igraph
      pacman
      pak
      rix
      shinychat
      shinylive
      simstudy
      styler
      survival
      survminer
      targets
      tidymodels
      tidyplots
      tidyquant
      tidyverse
      units
      usethis;
  };
 
    cmdstanr = (pkgs.rPackages.buildRPackage {
      name = "cmdstanr";
      src = pkgs.fetchgit {
        url = "https://github.com/stan-dev/cmdstanr";
        rev = "2d65dde3bc4a1a8c4d94e62a9185efaab473eda3";
        sha256 = "sha256-XwOYPn0yKjaz2t2PLmSjEtgX6+EUrGurvaWklGHupmw=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          checkmate
          data_table
          jsonlite
          posterior
          processx
          R6
          withr
          rlang;
      };
    });

    rixpress = (pkgs.rPackages.buildRPackage {
      name = "rixpress";
      src = pkgs.fetchgit {
        url = "https://github.com/b-rodrigues/rixpress";
        rev = "6382a09f2686a87eadec5534d35a285944f5a9d4";
        sha256 = "sha256-RgdXyoYvna0JukQfnpqgwLUVrTpu1XMWBlyltoeeh8s=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          igraph
          jsonlite
          rix;
      };
    });
    
  system_packages = builtins.attrValues {
    inherit (pkgs) 
      gettext
      git
      glibcLocales
      less
      nix
      positron-bin
      R
      radianWrapper
      toybox;
  };
  
in

pkgs.mkShell {
  LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  LANG = "en_US.UTF-8";
   LC_ALL = "en_US.UTF-8";
   LC_TIME = "en_US.UTF-8";
   LC_MONETARY = "en_US.UTF-8";
   LC_PAPER = "en_US.UTF-8";
   LC_MEASUREMENT = "en_US.UTF-8";

  buildInputs = [ rixpress cmdstanr rpkgs  system_packages   ];
  
}
