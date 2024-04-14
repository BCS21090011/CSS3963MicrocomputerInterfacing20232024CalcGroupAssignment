TITLE   LABORATORY 8

        PAGE    ,132

STACK_SEG       SEGMENT         STACK 'STACK'
                DB              64 DUP(?)
STACK_SEG       ENDS

DATA_SEG        SEGMENT         'DATA'
ARRAY_BEG       DW      400H
ARRAY_END       DW      41EH
DATA_SEG        ENDS

CODE_SEG        SEGMENT         'CODE'
LAB8    PROC FAR
        ASSUME  CS:CODE_SEG, SS:STACK_SEG, DS:DATA_SEG

        PUSH    DS      ; Save the value in DS into the stack, probably to preserve it.
        MOV     AX,0    ; Store '0' in AX.
        PUSH    AX      ; Save the value in AX, which is '0', into the stack.
        /*
        '0' needed to be store in AX and then pushed into the stack is because
        some processors doesn't support pushing immediate value (hardcoded value)
        into the stack, so needed AX is used as an intermediate.

        Immediate value: Hardcoded value such as 0x1234, 0xFF, or in this context, the
        processer allocated DATA_SEG. Immediate value can be used directly and doesn't
        needed to be "fetched" from other place. Example: "MOV AX, 0xABCD"

        Register value: Values from register, i.e., values from AX, AH, AL, BX, BH, BL,
        CX, CH, CL, DX, DH, and DL. Example: "MOV AX, BX"

        Memory value: Values from memory, needed to be fetched by address. The address can be
        immediate value (direct address) or register value (indirect address).
        Example: "MOV AX, [0x1234]", "MOV AX, [BX]"
        */

        MOV     AX, DATA_SEG    ; Store DATA_SEG in AX.
        MOV     DS, AX          ; Store the data in AX, which is DATA_SEG, in DS.
        /* 
        AX is needed as an intermediate because immediate value can't be store directly
        into the segment register.

        DS needed to be set as DATA_SEG so that the data can be worked in allocated and intended
        "place".
        */

        MOV     SI, ARRAY_BEG   ; Initialize SI as ARRAY_BEG.
        MOV     BX, ARRAY_END   ; Initialize BX as ARRAY_END.
AA:     MOV     DI, SI          ; DI = SI
        ADD     DI, 2           ; DI += 2
BB:     MOV     AX, [SI]        ; AX = [SI]
        CMP     AX, [DI]        ; if AX <= [DI]
        JLE     CC              ; Jump to CC.
        MOV     DX, [DI]        ; Store the data pointed by DI from memory to DX.
        MOV     [SI], DX        ; Store the data of DX to memory pointed by [SI].
        MOV     [DI], AX        ; Store the data of AX to memory pointed by [DI].
CC:     INC     DI              ; DI += 1
        INC     DI              ; DI += 1
        CMP     DI, BX          ; if DI <= BX
        JBE     BB              ; Jump to BB.
        INC     SI              ; SI += 1
        INC     SI              ; SI += 1
        CMP     SI, BX          ; if SI < BX
        JB      AA              ; Jump to AA.
DONE:   NOP                     ; Nothing.
        RET                     ; Return
LAB8    ENDP
CODE_SEG        ENDS
        END     LAB8


/*
OPERAND a, b

JLE: Jump if a lower or equal than b (for signed)
JBE: Jump if a below or equal than b (for unsigned)
JB: Jump if a below than b (for unsigned)

MOV: Move b to a (b value unchanged)
CMP: Compare a to b
INC: a += 1
*/

/*
Flowchart (can view in "https://app.code2flow.com/" using the code below):
	Start;
	SI = ARRAY_BEG;
	BX = ARRAY_END;
AA:
	DI = SI;
	DI += 2;  // DI points to the next data of that of SI (since each data is two bytes).
BB:
	AX = \[SI\];
	if AX <= [DI] {
                loop CC
	} else {
  	// Swap [SI] and [DI]:
    DX = \[DI\];
    [SI] = DX;
  	[DI] = AX;  // AX currently is [SI].
	}
CC:
	DI += 1;
	DI += 1;
	if DI <= BX { // If DI not reach the end (can be last data in array):
        loop BB
	} else {
    SI += 1;
    SI += 1;
  	if SI < BX {  //  If SI not reach the end and is not the last data in array:
        loop AA
    }
DONE:
	return
	End;
*/

/*
Python equivalent:
```Python
class LAB8:
    def __init__(self, mem: list):
        # Initialize:

        self.SI: int = 0
        self.DI: int = 0
        self.AX: int = 0
        self.BX: int = 0
        self.CX: int = 0
        self.DX: int = 0

        self.MEM: list = mem
        self.ARRAY_BEG: int = 0
        self.ARRAY_END: int = len(self.MEM) - 1

        # Codes:
        
        self.SI = self.ARRAY_BEG
        self.BX = self.ARRAY_END
        
        # To mimic how assembly flow:
        self.AA()
    
    def AA (self):
        # Two indexes, SI is pointing to current data and DI is pointing to next data:
        self.DI = self.SI
        self.DI += 1
        
        # To mimic how assembly flow:
        self.BB()

    def BB (self):
        self.AX = self.MEM[self.SI]
        if self.AX <= self.MEM[self.DI]:	# if MEM[SI] <= MEM[DI]:
            # Skip swap:
            self.CC()
        else:
            # Swap MEM[SI] and MEM[DI]:
            self.DX = self.MEM[self.DI]
            self.MEM[self.SI] = self.DX
            self.MEM[self.DI] = self.AX
        
            # To mimic how assembly flow:
            self.CC()

    def CC (self):
        # Loop and compare every data with current MEM[SI]:
        self.DI += 1
        if self.DI <= self.BX:
            self.BB()
        else:
            # Loop, change SI, and compare again, data before MEM[SI] are sorted:
            self.SI += 1
            
            if self.SI < self.BX:
                self.AA()
            else:
                # To mimic how assembly flow:
                self.DONE()

    def DONE (self):
        return
```
*/

/*
This is a bubble sort algorithm where it will sort the value into the correct "position"
first.
There will be two "pointers", one pointing current "position", SI in this context;
another pointing to the next "position", DI in this context.

Algorithm:
```
for SI in range(len(Arr)-1):
    for DI in range(SI+1, len(Arr)):
        if Arr[DI] < Arr[SI]:
            Arr = Swap(Arr, SI, DI)
```

Bubble sort algorithm in Python:
```Python
def Swap(arr: list, index1: int, index2: int) -> list:
	retArr: list = arr.copy()

	tmp = retArr[index1]
	retArr[index1] = retArr[index2]
	retArr[index2] = tmp

	return retArr

def BubbleSort(arr: list) -> list:
	Arr: list = arr.copy()
	
	for cI in range(len(Arr)-1):
		for nI in range(cI+1, len(Arr)):
			if Arr[nI] < Arr[cI]:
				Arr = Swap(Arr, cI, nI)
	return Arr
```

Example:
Sorting:	[1, 2, 6, 4, 5, 3]
Before:	[1, 2, 6, 4, 5, 3]
	SI:	0
	DI:	1
		DI(2) greater than SI(1)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	0
	DI:	2
		DI(6) greater than SI(1)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	0
	DI:	3
		DI(4) greater than SI(1)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	0
	DI:	4
		DI(5) greater than SI(1)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	0
	DI:	5
		DI(3) greater than SI(1)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	1
	DI:	2
		DI(6) greater than SI(2)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	1
	DI:	3
		DI(4) greater than SI(2)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	1
	DI:	4
		DI(5) greater than SI(2)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	1
	DI:	5
		DI(3) greater than SI(2)
Before:	[1, 2, 6, 4, 5, 3]
	SI:	2
	DI:	3
		DI(4) smaller than SI(6):
			Swap SI with DI
			Swapped:	[1, 2, 4, 6, 5, 3]
Before:	[1, 2, 4, 6, 5, 3]
	SI:	2
	DI:	4
		DI(5) greater than SI(4)
Before:	[1, 2, 4, 6, 5, 3]
	SI:	2
	DI:	5
		DI(3) smaller than SI(4):
			Swap SI with DI
			Swapped:	[1, 2, 3, 6, 5, 4]
Before:	[1, 2, 3, 6, 5, 4]
	SI:	3
	DI:	4
		DI(5) smaller than SI(6):
			Swap SI with DI
			Swapped:	[1, 2, 3, 5, 6, 4]
Before:	[1, 2, 3, 5, 6, 4]
	SI:	3
	DI:	5
		DI(4) smaller than SI(5):
			Swap SI with DI
			Swapped:	[1, 2, 3, 4, 6, 5]
Before:	[1, 2, 3, 4, 6, 5]
	SI:	4
	DI:	5
		DI(5) smaller than SI(6):
			Swap SI with DI
			Swapped:	[1, 2, 3, 4, 5, 6]
Sorted:	[1, 2, 3, 4, 5, 6]
*/