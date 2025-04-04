# ./default.sh
# sudo rm -rf /private/tmp/nix-shell-* /tmp/Rtmp* && nix-collect-garbage -d

echo "from rix only (via env default_R_nix_only.nix)
    \tto all R pkgs
    \t(default_sym.R -> default.R -> env default.nix)\n" && \
nix-shell \
    --pure \
    --keep GITHUB_PAT \
    --command \
        "Rscript --vanilla default_sym.R" \
    default_R_nix_only.nix

echo "\n\nrestart (all packages) (env ./default.nix + positron)" && \
echo "\tNB: ignoring --pure \ # to avoid ~/.Rprofile\n\t\tbut ./.Rprofile should do this already?" && \
nix-shell \
    --pure \
    --keep GITHUB_PAT \
    --argstr myVar "some value" \
    --command \
    " \
        positron ; echo $myVar ; return\
    " \
    default.nix
    # NB: --pure do NOT
        # allow writing to /tmp/private needed by cmdstanr
        # Error 'ENOENT'??: no such file or directory, open '/private/tmp/nix-shell-82530-0/kallichore-4a46d10c.token'
    # --argstr myVar "some value" -p hello --run 'echo $myVar'
    # --command "unset R_LIBS_USER"
    # Sys.getenv("R_LIBS_USER") ; Sys.unsetenv("R_LIBS_USER") ; Sys.getenv("R_LIBS_USER")

        # echo '  R_LIBS_USER="." to enforce --pure' && \
        # export R_LIBS_USER='.' && \
        # echo '  R_LIBS="" to enforce --pure' && \
        # export R_LIBS='' && \
        # echo '  to help enforce --pure: do NOT call ~/.Rprofile i.e. call ./.Rprofile_$
        # touch ./empty_rprofile && \
        # export R_PROFILE_USER=./empty_rprofile && \
