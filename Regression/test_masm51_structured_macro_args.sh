#!/bin/sh
set -eu

assembler=${1:-build/GccUnixR/jwasm}
workdir=$(mktemp -d "${TMPDIR:-/tmp}/jwasm-m510-args.XXXXXX")
trap 'rm -rf "$workdir"' EXIT HUP INT TERM

cat > "$workdir/test.asm" <<'EOF'
.model tiny
.code
option nokeyword:<.if .for>
.IF macro condition
    db 1
endm
.FOR macro reg,assignment,first,direction,last
    db first
    db last
endm
start:
    .IF <1 EQ 1>
    .FOR BX = 2 TO 3
end start
EOF

"$assembler" -q -Zm -bin -Fo="$workdir/out.bin" "$workdir/test.asm"
test "$(od -An -tu1 "$workdir/out.bin" | tr -d ' \n')" = 1123
echo "MASM 5.10 structured macro whitespace arguments passed"
