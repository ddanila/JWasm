; MASM 5.1 derives the operand size from an indexed structure member.

rec_type STRUC
    tag DB ?
rec_type ENDS

code SEGMENT USE16
    ASSUME CS:code
    cmp [bx][di].tag, 1
code ENDS
END
