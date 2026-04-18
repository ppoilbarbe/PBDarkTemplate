#!/bin/bash

HERE="$(dirname "$(realpath "$0")")"
BUILD_DIR="$HERE/build"
BUILD_MOVIES=PBDarkTemplateMovies
BUILD_TVSHOWS=PBDarkTemplateTVShows

function error() {
    echo "ERROR: $*"
    exit 1
}
function cmd() {
    echo "===== Command: $*"
    "$@" || error "Error with the command"
}

function build() {
    local WHAT="$1"
    local WHERE="$2"
    cmd mkdir -p "$BUILD_DIR"
    cmd cd "$BUILD_DIR"
    cmd rm -rfv  "$WHERE"
    cmd mkdir -p "$WHERE"
    cmd cp "$HERE/$WHAT"/*  "$WHERE"
    cmd cp "$HERE"/common/* "$WHERE"
    cmd rm -fv "$WHERE.zip"
    cmd zip -9r "$WHERE.zip" "$WHERE"
}

for name in ${*:-movies tvshows} ; do
    echo "======================== Building $name"
    case "$name" in
        movies)
            build "$name" "$BUILD_MOVIES"
            ;;
        tvshows)
            build "$name" "$BUILD_TVSHOWS"
            ;;
        clean)
            cmd rm -rfv "$BUILD_DIR"
            ;;
        *)
            error "Unknown build '$name'"
            ;;
    esac
done
