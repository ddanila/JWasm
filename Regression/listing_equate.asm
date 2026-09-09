.386
CODE16 segment use16
db 90h
EQU16 equ $-1
dw EQU16
CODE16 ends
CODE32 segment use32
db 90h
EQU32 equ $-1
dd EQU32
WIDE equ 123456789ABCDEF0h
NEGATIVE equ -1
CODE32 ends
end
