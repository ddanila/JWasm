#!/bin/sh
set -eu

assembler=${1:-build/GccUnixR/jwasm}
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

"$assembler" -q -Zm -bin -Fo="$tmpdir/forward.bin" \
    "$(dirname "$0")/masm51_forward_jmp.asm"

actual=$(od -An -tx1 -N4 "$tmpdir/forward.bin" | tr -d ' \n')
expected=e9000090
if [ "$actual" != "$expected" ]; then
    echo "MASM 5.1 forward JMP encoding: expected $expected, got $actual" >&2
    exit 1
fi
