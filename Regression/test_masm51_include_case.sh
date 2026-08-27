#!/bin/sh
set -eu

assembler=${1:-build/GccUnixR/jwasm}
workdir=$(mktemp -d "${TMPDIR:-/tmp}/jwasm-m510-case.XXXXXX")
trap 'rm -rf "$workdir"' EXIT HUP INT TERM
mkdir "$workdir/Includes"
printf 'db 42\n' > "$workdir/Includes/MixedCase.INC"
printf 'include includes/mixedcase.inc\nend\n' > "$workdir/main.asm"
"$assembler" -q -Zm -bin -Fo="$workdir/out.bin" "$workdir/main.asm"
test "$(od -An -tu1 "$workdir/out.bin" | tr -d ' \n')" = 42
echo "MASM 5.10 case-insensitive include lookup passed"
