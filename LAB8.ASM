TITLE   LABORATORY 8

        PAGE    ,132

STACK_SEG       SEGMENT         STACK 'STACK'
                DB              64 DUP(?)
STACK_SEG       ENDS

DATA_SEG        SEGMENT         'DATA'
ARRAY_BEG       DW      400H
ARRAY_END       DW      40EH
DATA_SEG        ENDS

CODE_SEG        SEGMENT         'CODE'
LAB8    PROC FAR
        ASSUME  CS:CODE_SEG, SS:STACK_SEG, DS:DATA_SEG

        PUSH    DS
        MOV     AX,0
        PUSH    AX

        MOV     AX, DATA_SEG
        MOV     DS, AX
        MOV     SI, ARRAY_BEG
        MOV     BX, ARRAY_END
AA:     MOV     DI, SI
        ADD     DI, 2
BB:     MOV     AX, [SI]
        CMP     AX, [DI]
        JLE     CC
        MOV     DX, [DI]
        MOV     [SI], DX
        MOV     [DI], AX
CC:     INC     DI
        INC     DI
        CMP     DI, BX
        JBE     BB
        INC     SI
        INC     SI
        CMP     SI, BX
        JB      AA
DONE:   NOP
        RET
LAB8    ENDP
CODE_SEG        ENDS
        END     LAB8
