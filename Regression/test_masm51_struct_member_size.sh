#!/bin/sh
set -eu

JWASM=${1:-./jwasm}
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TMPDIR_PATH=$(mktemp -d "${TMPDIR:-/tmp}/jwasm-member-size.XXXXXX")
trap 'rm -rf "$TMPDIR_PATH"' EXIT HUP INT TERM

"$JWASM" -q -Zm -bin -Fo="$TMPDIR_PATH/member.bin" \
    "$HERE/masm51_struct_member_size.asm"

actual=$(od -An -tx1 -v "$TMPDIR_PATH/member.bin" | tr -d ' \n')
expected=803901

if [ "$actual" != "$expected" ]; then
    echo "indexed byte member encoded as $actual, expected $expected" >&2
    exit 1
fi
