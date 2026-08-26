; MASM 5.1 preserves a structure member's type through an EQU alias.

boot_record STRUC
    signature DB ?
    serial    DD ?
boot_record ENDS

serial_field EQU boot_record.serial

code SEGMENT USE16
    ASSUME CS:code
    mov cx, TYPE serial_field
code ENDS
END
