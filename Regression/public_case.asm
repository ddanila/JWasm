; CASEMAP:NOTPUBLIC must take exported spelling from the PUBLIC directive.
; The generated OMF PUBDEF must contain MixedCaseName, not MIXEDCASENAME.

option casemap:notpublic

code segment use16 public 'CODE'

public MixedCaseName
MIXEDCASENAME:
    ret

code ends
end
