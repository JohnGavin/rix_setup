# mkdir nix_setup && cd nix_setup
# ./default.sh
# Rscript --vanilla default_sym.R
# nix-store --gc
#  rm -rf /private/tmp/nix-shell-* && nix-collect-garbage -d

### Startup with rix only
# nix-shell --pure --expr "$(curl -sl https://raw.githubusercontent.com/b-rodrigues/rix/master/inst/extdata/default.nix)"
# --vanilla else ~/.Rprofile is run
# R --vanilla -e "source('./default_sym.R')"   && cat default.nix

# https://ropensci.r-universe.dev/articles/rix/c-using-rix-to-build-project-specific-environments.html
# nix-shell default.nix --run "Rscript -e 'targets::tar_make()'"

r_pkgs = c(
  # https://www.rdatagen.net/post/2025-02-11-estimating-a-bayesian-proportional-hazards-model/
  "simstudy", "data.table", "survival", "survminer", # "cmdstanr",
  "brms", # needs gettext else 'intl' mac error
  # https://github.com/jcheng5/pharma-sidebot
  # "DBI", "duckdb", "fastmap", "fontawesome", "ggridges", "here", "plotly", "reactable", "shiny", # "hadley/elmer", "jcheng5/shinychat",
  "checkglobals", # https://github.com/JorisChau/checkglobals
  "DiagrammeR",
  # "gtools", # "Rmpfr",
  # "reticulate", # forces python to be included?
  "igraph", # for rixexpress
  # https://www.jumpingrivers.com/blog/sparkline-reactable/
  # "reactable", "sparkline",
  # https://www.seascapemodels.org/rstats/2025/03/15/LMs-in-R-with-ellmer.html
  "tidyverse",
  "tidymodels",
  "tidyquant",
  # "earth", "tsibble", "timetk", "modeltime",
  "ellmer",
  "shinychat",
  "bslib",
  "shinylive",
  "dplyr",
  "ggplot2",
  "targets",
  "rix",
  "tidyverse",
  "tidyplots", # "tidyheatmaps",
  "units",
  # "tidyRSS", # "tidygeoRSS", # => sf geospatial
  "pak",
  "pacman",
  "devtools",
  # Error while sourcing R profile file at path '/Users/johngavin/.Rprofile':
  "usethis", # devtools alone not enough
  "styler" # for nix-shell --pure ... && R --vanilla
) |>
  unique() |>
  sort()
# pacman::p_load(r_pkgs, character.only = T)

git_pkgs <- rlang::list2(
  # NULL
  # https://brodrigues.co/posts/2025-03-20-announcing_rixpress.html
  list(
    package_name = "rixpress",
    repo_url = "https://github.com/b-rodrigues/rixpress",
    commit = "6382a09f2686a87eadec5534d35a285944f5a9d4"
  ),
  # https://www.rdatagen.net/post/2025-02-11-estimating-a-bayesian-proportional-hazards-model/
  list(
    package_name = "cmdstanr",
    repo_url = "https://github.com/stan-dev/cmdstanr",
    commit = "2d65dde3bc4a1a8c4d94e62a9185efaab473eda3"
  ),

  # list(
  #   package_name = "elmer",
  #   repo_url = "https://github.com/hadley/elmer",
  #   commit = "4780a4edc8dbadce3e955554aa18eea25e30b27e"),
  # list(
  #   package_name = "shinychat",
  #   repo_url = "https://github.com/jcheng5/shinychat",
  #   commit = "f1ddb37ad9c7ed3c22db9446564f6bb2e062f389"),

  # https://www.seascapemodels.org/rstats/2025/03/17/LLMs-in-R-tool-use.html
  #  ocean data from the IMOS BlueLink database.
  #  # /nix/store/pbkhxcwbkn6rp2xzprprw5lzj3dwz56g-r-RNetCDF-2.9-2.drv fails
  # list(
  #    package_name = "remora",
  #    repo_url =  "https://github.com/IMOS-AnimalTracking/remora/",
  #    commit = "f461f826799133c6c599ba624c2b093058d03884"),
  #  list(
  #    package_name = "housing",
  #    repo_url = "https://github.com/rap4all/housing/",
  #    commit = "1c860959310b80e67c41f7bbdc3e84cef00df18e"),
  # list(
  #   package_name = "fusen",
  #   repo_url = "https://github.com/ThinkR-open/fusen",
  #   commit = "d617172447d2947efb20ad6a4463742b8a5d79dc")
)

system_pkgs <- c(
  "radianWrapper",
  "git",
  "toybox", # coreutils-full # else 'which' etc is missing with nix-shell --pure
  # translation tools - gettext
  #   else brms 'intl' error libintl-dev
  "gettext",
  "less" # pager needs less
  # , "gmp", "mpfr"
)

# shellHook as string
# Crucially, use single quotes
# *inside* the string, and double quotes around the entire string,
# because we're going to be embedding this inside a Nix string later.
shell_hook <- ""
#"
#   paste0(
#     "export CPATH='${pkgs.gmp.dev}/include:${pkgs.mpfr.dev}/include:$CPATH'\n",
#     "export LIBRARY_PATH='${pkgs.gmp.out}/lib:${pkgs.mpfr.out}/lib:$LIBRARY_PATH'\n",
#     "      echo 'R environment ready with GMP and MPFR.'\n"
#   ))
# #"
# (shell_hook <- paste0(c("unset R_LIBS_USER", "export R_LIBS_USER='.'")[2], "; export R_LIBS=''"))


py_pkgs = list(
  py_version = "3.12",
  py_pkgs = c("polars", "great-tables")
)

library(rix)
rix(
  date = "2025-03-03", # or	r_ver = "4.4.3"
  project_path = ".",
  overwrite = TRUE,
  r_pkgs = r_pkgs,
  # py_pkgs = py_pkgs,
  system_pkgs = system_pkgs,
  git_pkgs = git_pkgs,
  tex_pkgs = NULL,
  ide = c("positron", "rstudio")[1],
  shell_hook = shell_hook
  #shell_hook = " export R_LIBS_USER=."
)

nix_build() # project_path = "./default.nix")
# exit # from current shell
# enter newest shell
# nix-shell --pure # avoid ~/.Rprofile but ./.Rprofile should do this already?
# which R && which positron # toybox else 'which' fails on mac M2! cos --pure
# R -e ' pacman::p_load(c(
# "dplyr",
# "ggplot2",
# # "brms", # needs gettext else \'intl\' error on mac M2
# "targets",
# "rix",
# "tidyverse",
# "pak", "pacman",
# "usethis" # else nix-shell --pure ... && R --vanilla
# ), character.only = TRUE )
# '
