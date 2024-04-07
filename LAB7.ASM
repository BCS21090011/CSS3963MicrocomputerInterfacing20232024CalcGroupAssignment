TITLE   LABORATORY 7

        PAGE    ,132

STACK_SEG       SEGMENT         STACK 'STACK'
                DB              64 DUP(?)
STACK_SEG       ENDS

DATA_SEG        SEGMENT         'DATA'
COUNT           DB      16
BUFFER          DD      10000000H
DATA_SEG        ENDS

CODE_SEG        SEGMENT         'CODE'
LAB7    PROC    FAR
        ASSUME  CS:CODE_SEG, SS:STACK_SEG, DS:DATA_SEG

        PUSH    DS
        MOV     AX,0
        PUSH    AX

        MOV     AX, DATA_SEG
        MOV     DS, AX
        MOV     CL, COUNT
        MOV     BL,CL
        LDS     SI, BUFFER
        MOV     DX, 0
NXTPT:  MOV     AL, [SI]
        CBW
        ADD     DX,AX
        INC     SI
        DEC     CL
        JNZ     NXTPT
        MOV     AX, DX
        IDIV    BL
        RET
LAB7    ENDP
CODE_SEG        ENDS
        END     LAB7
