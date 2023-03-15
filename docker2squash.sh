#!/usr/bin/fakeroot /bin/bash
# https://gist.github.com/hashbrowncipher/9b811bad8353a7246695a1e2bfea0e84
set -o errexit
set -o nounset
set -o pipefail
OUTFILE=$2.squashfs
TMPDIR=$(mktemp -d -p .)

cleanup() {
  rm -fr "$TMPDIR"
}

trap cleanup EXIT

CONTAINER=$(docker create "$1")
docker export "$CONTAINER" | tar -C "$TMPDIR" -p -s --same-owner -xv
docker rm "$CONTAINER"
mksquashfs "$TMPDIR" "$OUTFILE" -info -processors 1 -noappend -comp xz -Xdict-size 100%
