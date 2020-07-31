#!/bin/bash

SCRIPT_NAME="$0"
REPO="$1"

function error()
{
    pkg="${1+$1: }"
    shift
    echo "$SCRIPT_NAME: $pkg}$*" >&2
    exit 1
}

echo "Cleaning cache and old build files"
buildpkg -w
rm -rf build 2>/dev/null

mkdir build
pushd build

while read pkg; do
    if yay -G "$pkg"; then
        buildpkg "$pkg" || error "$pkg" "buildpkg exited with status $?"
    else
        error "$pkg" "could not clone pkgbuild repository. Yay exitted with status $?"
    fi
done

popd
repo-add -pR "$REPO" /var/cache/manjaro-tools/pkg/stable/*.pkg.tar.* || error "" "repo-add exited with status $?"
