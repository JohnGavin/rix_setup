# ./default.sh
# sudo rm -rf /private/tmp/nix-shell-* /tmp/Rtmp* && nix-collect-garbage -d

echo "from rix only (default_R_nix_only.nix)\n\tto all pkgs\n\t(default_sym.R -> default.R -> default.nix)" && \
nix-shell \
    --pure \
    --keep GITHUB_PAT \
    --command \
        "Rscript --vanilla default_sym.R" \
    default_R_nix_only.nix

echo "\n\nrestart (all packages) (./default.nix + positron)" && \
#    --pure \
nix-shell \
    --keep GITHUB_PAT \
    --command \
    " \
        echo 'R_LIBS_USER="." to enforce --pure' && \
        export R_LIBS_USER='.' && \
        echo 'R_LIBS="" to enforce --pure' && \
        export R_LIBS='' && \
        echo 'do not call ~/.Rprofile to enforce --pure' && \
        touch ./empty_rprofile && \
        export R_PROFILE_USER=./empty_rprofile && \
        positron \
    " \
    default.nix
    # --command "unset R_LIBS_USER && positron"
    # Sys.getenv("R_LIBS_USER") ; Sys.unsetenv("R_LIBS_USER")
    # --argstr myVar "some value" -p hello --run 'echo $myVar'
