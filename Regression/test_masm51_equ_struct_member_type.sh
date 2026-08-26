#!/bin/sh
set -eu

JWASM=${1:-./jwasm}
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TMPDIR_PATH=$(mktemp -d "${TMPDIR:-/tmp}/jwasm-equ-member-type.XXXXXX")
trap 'rm -rf "$TMPDIR_PATH"' EXIT HUP INT TERM

"$JWASM" -q -Zm -bin -Fo="$TMPDIR_PATH/member.bin" \
    "$HERE/masm51_equ_struct_member_type.asm"

actual=$(od -An -tx1 -v "$TMPDIR_PATH/member.bin" | tr -d ' \n')
expected=b90400

if [ "$actual" != "$expected" ]; then
    echo "TYPE of EQU-aliased DWORD member encoded as $actual, expected $expected" >&2
    exit 1
fi
