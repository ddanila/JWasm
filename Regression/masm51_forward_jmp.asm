; MASM 5.1 keeps an implicit forward JMP near, even when the destination is
; in short range. Structured macro packages use the resulting three-byte
; instruction in fixed-size skip sequences such as Jcc $+5 / JMP label.

code segment use16
start:
    jmp target
target:
    nop
code ends
end
