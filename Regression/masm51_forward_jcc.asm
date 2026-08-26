; MASM 5.1 keeps an in-range forward conditional branch short.  The special
; implicit-forward-JMP handling must not expand Jcc instructions.

code segment use16
start:
    je target
target:
    nop
code ends
end
