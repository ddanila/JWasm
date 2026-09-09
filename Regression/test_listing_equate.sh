#!/bin/sh
set -eu

# Use an optimized build with -D_FORTIFY_SOURCE=3 to detect the original
# sprintf write past the listing header's array boundary.
JWASM=${1:-./build/GccUnixR/jwasm}
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
WORK=$(mktemp -d "${TMPDIR:-/tmp}/jwasm-listing-equate.XXXXXX")
trap 'rm -rf "$WORK"' EXIT HUP INT TERM

"$JWASM" -q -Zm -Fo"$WORK/plain.obj" "$HERE/listing_equate.asm"
for mode in normal first; do
    case "$mode" in
        normal) set -- ;;
        first) set -- -Sf ;;
    esac
    "$JWASM" -q -Zm "$@" -Fl"$WORK/$mode.lst" -Fo"$WORK/$mode.obj" \
        "$HERE/listing_equate.asm"
    cmp "$WORK/plain.obj" "$WORK/$mode.obj"
    # Source text must stay at column 33 after either offset width, and the
    # displayed values must remain intact.
    awk '
        substr($0,33) == "EQU16 equ $-1" { if (substr($0,1,8) != "0001 = 0") exit 1; a++ }
        substr($0,33) == "EQU32 equ $-1" { if (substr($0,1,12) != "00000001 = 0") exit 1; b++ }
        substr($0,33) == "WIDE equ 123456789ABCDEF0h" { if (index(substr($0,1,32), "123456789ABCDEF0") == 0) exit 1; c++ }
        substr($0,33) == "NEGATIVE equ -1" { if (index(substr($0,1,32), "FFFFFFFF") == 0) exit 1; d++ }
        END { if (a != 1 || b != 1 || c != 1 || d != 1) exit 1 }
    ' "$WORK/$mode.lst"
done
