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

echo "\n\nrestart (all packages) (env ./default.nix + positron)\n" && \
echo "\tNB: ignoring --pure \ # to avoid ~/.Rprofile but ./.Rprofile should do this already?\n" && \
nix-shell \
    --keep GITHUB_PAT \
    --command \
    " \
        echo 'R_LIBS_USER="." to enforce --pure' && \
        export R_LIBS_USER='.' && \
        echo 'R_LIBS="" to enforce --pure' && \
        export R_LIBS='' && \
        echo 'to help enforce --pure: do NOT call ~/.Rprofile i.e. call ./.Rprofile_empty instead' && \
        touch ./empty_rprofile && \
        export R_PROFILE_USER=./empty_rprofile && \
        positron \
    " \
    default.nix
    # --argstr myVar "some value" -p hello --run 'echo $myVar'
    # --command "unset R_LIBS_USER"
    # Sys.getenv("R_LIBS_USER") ; Sys.unsetenv("R_LIBS_USER") ; Sys.getenv("R_LIBS_USER")
