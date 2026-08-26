#!/bin/sh
set -eu

jwasm=${1:-./build/GccUnixR/jwasm}
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT HUP INT TERM

"$jwasm" -q -Zm -bin -Fo"$workdir/out.bin" \
    Regression/masm51_forward_jcc.asm

actual=$(od -An -tx1 -v "$workdir/out.bin" | tr -d ' \n')
expected=740090
test "$actual" = "$expected" || {
    echo "forward Jcc encoding mismatch: expected $expected, got $actual" >&2
    exit 1
}
