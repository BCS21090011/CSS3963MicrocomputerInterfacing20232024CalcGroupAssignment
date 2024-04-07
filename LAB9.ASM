TITLE   LABORATORY 9

        PAGE    ,132

STACK_SEG       SEGMENT         STACK 'STACK'
                DB              64 DUP(?)
STACK_SEG       ENDS

DATA_SEG        SEGMENT         'DATA'
NUM1            DB              ?
NUM2            DB              ?
FIBSER          DB              ?
DATA_SEG        ENDS


CODE_SEG        SEGMENT         'CODE'
LAB9    PROC    FAR
        ASSUME  CS:CODE_SEG, SS:STACK_SEG, DS:DATA_SEG

        PUSH    DS
        MOV     AX,0
        PUSH    AX

        MOV     AX, DATA_SEG
        MOV     DS, AX
        MOV     NUM1, 0
        MOV     NUM2, 1
        MOV     FIBSER, 0
        MOV     FIBSER+1, 1
        LEA     DI, FIBSER+2
        MOV     CX, 8
NXTNM:  CALL    SBRTF
        DEC     CX
        JNZ     NXTNM
DONE:   NOP
        RET

SBRTF   PROC    NEAR
        PUSH    AX
        PUSH    BX
        MOV     AL, NUM1
        MOV     BL, NUM2
        ADD     AL, BL
        MOV     [DI], AL
        MOV     NUM1, BL
        MOV     NUM2, AL
        INC     DI
        POP     BX
        POP     AX
        RET
SBRTF   ENDP

LAB9    ENDP
CODE_SEG        ENDS
        END     LAB9
