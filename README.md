# Calculator
[Original Source]()

This is for group assignment for *CSS3963 Microcomputer Interfacing 2023-2024*. The codes is intended to run in DOSBox.

## Group members:
* To be filled if wanted.


## Code Explanation:

### CALC5.ASM:

```ASM
.model small
.stack 100h
```

* `.model small`:
  * See [**Setups**](#setups).
* `.stack 100h`: 
  * See [**Setups**](#setups).
  * `100h` (or 256 in decimal) specifies the size of the stack segment. In this case, 256 bytes are allocated for the stack.

---

```ASM
.data

inputMsg db "Enter number: $"
inputMsg1 db "Enter First number: $"
inputMsg2 db "Enter Second number: $" 
outputMsg db "Result = $"
invalidChoice db "Invalid Choice$"

msg1 db "Enter '+' for Addition$"
msg2 db "Enter '-' for Substraction$"
msg3 db "Enter '*' for Multiplication$"
msg4 db "Enter '/' for Division$"
msg5 db "Enter '%' for Modulus$"
msg6 db "Enter '!' for Factorial$", '13,10,$'
msg7 db "Enter '^' for Power$", '13,10,$'
msg8 db "Enter '2' for square$", '13,10,$'
msg9 db "Enter '3' for cube$", '13,10,$'
msg10 db "Enter 'e' for exit$"
msg11 db "Choice: $"

invalidMsg db "Invalid Number, Please Enter again: $"
newLine db 13,10,'$'

counter db 0			; store total digits in number
val dw 0				; number for output
temp db 0				; no of digits in number

num1 dw 1
num2 dw 1
```

* **`.data`**: See [**Segments**](#segments).
* **Display Strings:**
  * `inputMsg db "Enter number: $"`: Declares a message prompt for entering a number, terminated with a `$`, which DOS uses to know the end of the string when displaying it.
  * `inputMsg1 db "Enter First number: $"` and `inputMsg2 db "Enter Second number: $"`: Similar to `inputMsg`, these prompt the user to enter the first and second numbers for operations requiring two operands.
  * `outputMsg db "Result = $"`: This string is used to prefix the output result displayed to the user.
  * `invalidChoice db "Invalid Choice$"`: Message displayed when the user inputs is invalid.
  * `msg1` until `msg10` are messages displayed to the user indicating which character to input for performing specific operations (addition, subtraction, multiplication, division, modulus, factorial, power, square, cube, and exit the program, respectively).
    * `13,10,'&'` at the end of some messages inserts a new line (in [ASCII](https://www.asciitable.com/, "More about ASCII"), 13 is carriage return (`\r`), and 10 is line feed (`\n`)), then returns to the start of a new line, making the interface more readable.
  * `msg11 db "Choice: $"`: Similar to `inputMsg`, `inputMsg1`, and `inputMsg2`, this prompt user to enter the character of the operation wanted to perform.
  * `invalidMsg db "Invalid Number, Please Enter again: $"`: Message displayed when the user inputs an invalid number.
  * `newLine db 13,10,'$'`: This defines a new line character sequence used to separate outputs for readability.
* **Variables:**
  * `counter db 0`: A byte-sized variable used to store the total digits in a number, initialized to 0.
  * `val dw 0`: A word-sized variable (16 bits) used to store the result of the operation. It will also be used to store user input in `inputNumber`. It's initialized to 0.
  * `temp db 0`: A byte-sized variable initialized to 0. Never used.
  * `num1 dw 1` and `num2 dw 1`: Word-sized variables used to store the first and second numbers input by the user, respectively (`inputForNumbers` will use both `num1` and `num2`; `inputOneNumber` will only use `num1`). They are initialized to 1.

---

```ASM
.code

; main function
main proc
	mov ax,@data
	mov ds,ax
;display calculator interface
start:
	call printNewLine
	mov ah, 09h

	mov dx, offset msg1
	int 21h
	call printNewLine
	mov ah, 09h

	mov dx, offset msg2
	int 21h
	call printNewLine
	mov ah, 09h

	mov dx, offset msg3
	int 21h
	call printNewLine
	mov ah, 09h

	mov dx, offset msg4
	int 21h
	call printNewLine
	mov ah, 09h

	mov dx, offset msg5
	int 21h
	call printNewLine
	mov ah, 09h

	mov dx, offset msg6
	int 21h
	call printNewLine
	mov ah, 09h

    mov dx, offset msg7
	int 21h
	call printNewLine
	mov ah, 09h

    mov dx, offset msg8
	int 21h
	call printNewLine
	mov ah, 09h

    mov dx, offset msg9
	int 21h
	call printNewLine
	mov ah, 09h

	mov dx, offset msg10
	int 21h
	call printNewLine
	mov ah, 09h

	mov dx, offset msg11
	int 21h

	mov ah,01h
	int 21h
	
	call printNewLine
; check operation  
cmp al,'+'
JE addOp

cmp al,'-'
JE subOp

cmp al,'*'
JE mulOp

cmp al,'/'
JE divOp

cmp al,'%'
JE mudOp  ; Make sure this matches your modulus operation label

cmp al, '!'
JE factorialOp

cmp al, '^'
JE powerOp

cmp al, '2'
JE squareOp

cmp al, '3'
JE cubeOp

cmp al,'e'  ; Corrected from 'm' to 'e' for exit
JE exitProgram
mov ah,09h
mov dx, offset invalidChoice 
int 21h
JMP start
	
; perform operation	
addOp:
	call inputForNumbers
	call findSum
	JMP start
subOp:
	call inputForNumbers
	call findSub
	JMP start
mulOp:
	call inputForNumbers
	call findMul
	JMP start
divOp:
	call inputForNumbers
	call findDiv
	JMP start	
mudOp:
	call inputForNumbers
	call findMud
	JMP start

factorialOp:
    call inputOneNumber
    call findFactorial      ; Calculate factorial of num1, result in val
    mov ah, 09h
    mov dx, offset outputMsg
    int 21h
    call displayNumber      ; Display the result stored in val
    jmp start               ; Go back to the start

powerOp:
    call inputForNumbers
    call findPower
    jmp start

squareOp:
    call inputOneNumber
    mov num2, 02h
    call findPower
    jmp start

cubeOp:
    call inputOneNumber
    mov num2, 03h
    call findPower
    jmp start

exitProgram:		
	; exit of program
	mov ah,4ch
	int 21h

main endp
```

* `.code`: Marks the beginning of the code segment of the program. [More about segments](#segments).
* **`main proc`**: Defines the start of the `main` procedure.
  * `mov ax,@data`: Load the address of the data segment into `AX` register.
  * `mov ds, ax`: Move the value in `AX` to `DS` register, setting up the dta segment.
  * **start:**: A label indicating the start of the loop.
    * Display calculator interface:
      * `call printNewLine`: Calls a procedure to print a new line on the screen.
      * `mov ah, 09h`: Load the function code for printing a string in DOS into `AH`.
      * `mov dx, offset msg1`: Load the offset address of `msg1` into `DX`.
      * `int 21h`: DOS interrupt, will print `msg1`. [More about `INT` and `AH`](#interrupts).
      * Four steps above are repeated for `msg2` to `msg11`, displaying the options.
      * `mov ah,01h`: Load the function code for reading a character from the keyboard into `AH`.
      * `int 21h`: DOS interrupt, will read a character from the keyboard into `AL`. [More about `INT` and `AH`](#interrupts).
      * `call printNewLine`: Prints a new line after the user input.
    * Check operation:
      * `cmp al,'+'`: Compare the character entered by the user (stored in `AL`) with `'+'`.
      * `JE addOp`: Jump to addOp label if the previous line is equal, i.e., `al` is `'+'`.
      * Two steps above are repeated for each operations. Check if the user input is equal to the specific character and jump to the respective label if they are equal.
      * `mov ah,09h`: Prepare the function to print a string if the input is invalid. This line (and the lines below this line) will only execute if there are no jump for previous lines, which will check if the user input is equal to the characters for the operations, so if the code execute until here, it means that the user input does not match any characters for the operations, thus it is an invalid input.
      * `mov dx, offset invalidChoice`: Loads the address of the `invalidChoice` message to be printed.
      * `int 21h`: Prints the `invalidChoice` message.
      * `JMP start`: Jump back to the `start`, prompting the user again.
    * Perform operation:
      * **`addOp:`**: Label for addition operation.
        * `call inputForNumbers`: Calls procedure to input two numbers.
        * `call findSum`: Calls procedure to find the sum of the two numbers.
        * `JMP start`: Jumps back to start after operation is complete.
      * Similar labels and calls for `subOp`, `mulOp`, `divOp`, `mudOp` (modulus), `factorialOp`, `powerOp`, `squareOp`, and `cubeOp` with some calls `inputOneNumber` to allow for input one number instead of `inputForNumbers` which allow to input two numbers.
        * The codes in `factorialOp` is longer because the result is printed here rather than in the calculation procedure like what other operations did.
        * The code in `squareOp` and `cubeOp` are slighly different (`mov num2, 02h` and `mov num2, 03h` respectively) because it use predefined `num2`, which is exponent, and call `findPower` procedure.
      * **`exitProgram:`**: Label for exiting the program.
        * `mov ah,4ch`: Load the function code for terminating a program.
        * `int 21h`: DOS interrupt to terminate the program. [More about `INT` and `AH`](#interrupts).
* `main endp`: Marks the end of the `main` procedure. The `endp` directive is paired with the `proc` directive to define the bounds of a procedure in Assembly language.

---

```ASM
;take one number
inputOneNumber proc
    mov ah, 09h
    mov dx, offset inputMsg
    int 21h
    call inputNumber
    mov ax, val
    mov num1, ax
    ret
inputOneNumber endp
```

* `inputOneNumber proc`: Defines the start of the `inputOneNumber` procedure.
  * `mov ah, 09h`: Load the function code for printing a string in DOS into `AH`.
  * `mov dx, offset inputMsg`: Load the offset address of `inputMsg` into `DX`.
  * `int 21h`: Print `inputMsg`. [More about `INT` and `AH`](#interrupts).
  * `call inputNumber`: Call `inputNumber` procedure which will store the user input into `val`.
  * `mov ax, val`: Moves the value stored in `val` into `AX`.
  * `mov num1, ax`: Moves the value stored in `AX` into `num1`. `AX` is needed to move `val` to `num1` because it does not allow memory-to-memory move operation.
  * `ret`: Returns from the `inputOneNumber` procedure. The `ret` instruction is used to return control to the point where the `inputOneNumber` procedure was called.
* `inputOneNumber endp`: Marks the end of the `inputOneNumber` procedure.

---

```ASM
;take two numbers
inputForNumbers proc
	mov ah,09h
	mov dx, offset inputMsg1
	int 21h
	call inputNumber
	mov ax, val
	mov num1, ax
	mov ah,09h
	mov dx, offset inputMsg2
	int 21h
	call inputNumber
	mov ax, val
	mov num2, ax
	
ret
inputForNumbers endp
```



---

## Instruction Explanation:

### Setups:
* **`.model small`**:
  * Declares the memory model for the program. The x86 real-mode memory management supports different memory models, which determine how the program's code and data are organized in memory.
  * The `small` specifies that both the code and data segments of the program will fit within a single 64kb segment of memory. This is because, in real mode, memory is accessed through *segment:offset* pairs, which effectively limits the size of accessible memory at any one time to 64kb without changing the segment registers.
  * Using the `small` model simplifies memory management since the program can access both code and data using the same segment, which is especially useful for smaller programs.
* **`.stack {size}`**:
  * Allocates space for the stack in the program. The stack is a section of memory to stores temporary data such as function parameters, return addresses, and local variables.
  * The size needed depends on the complexity of the program, specifically the depth of function calls and the amount of local data used.
  * The stack is essentially for managing function calls and returns, among other things. If the program makes many nested function calls or requires significant temporary storage, larger stack might be needed.

### Datatypes:
* **`{name} db {value}`**: Used to declare a byte or array of bytes, often used for strings or single byte variables.
* **`{name} dw {value}`**: Declares a word (two bytes or 16 bits on x86 architectures), typically used for numerical variables where a byte would not be sufficient to hold the value.

### Segments:
The code in Assembly language is typically organize into different segments to separate the data definitions (`.data` segment) from the executable instructions (`.code` segment).

* **`.data`**:
  * Marks the beginning of the data segment in the program. This is where the place to define and initialize variables that will exist for the duration of the program's execution.
  * Variables declared in the `.data` segment are static/global and retain their values between function calls. This segment can include variables of various data types, initialized with specific values or reserved space for future use.
* **`.code`**:
  * This segment contains the actual instructions that the processor will execute.

### [Commons](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html):
* **`mov {a}, {b}`**:
  * Copy the data item referred to by `{b}` into location referred by `{a}`.
  * `{b}` can be register contents, memory contents, or a constant value.
  * `{a}` can be a register or memory.
  * Syntax:
    * `mov {reg},{reg}`
    * `mov {reg},{mem}`
    * `mov {mem},{reg}`
    * `mov {reg},{const}`
    * `mov {mem},{const}`
* **`push {a}`**: Place `{a}` to the top of the hardware supported stack in memory.
* **`pop {a}`**: Remove the top of the hardware supported stack into `{a}`.
* **`lea {a}, {b}`**: Place the address specified by `{b}` into register specified by `{a}`. Note, the contents of the memory location are not loaded, only the effective address is computed and placed into the register.
* [**`cmp {a}, {b}`**](https://www.tutorialspoint.com/assembly_programming/assembly_conditions.htm):
  * Compare `{a}` to `{b}`.
  * Usually use with [jumps](#jumps).

### [Jumps:](https://www.tutorialspoint.com/assembly_programming/assembly_conditions.htm)
Syntax: `JMP label` where `JMP` is the jump instruction and `label` is the label to jump to.

* Unconditional Jump:
  * `JMP`: Jump to the label without condition.

* Conditional Jump:
  * For signed data:

    | Instruction | Description |
    | :-: | :-: |
    | **`JE/JZ`** | Jump Equal / Jump Zero |
    | **`JNE/JNZ`** | Jump Not Equal / Jump Not Zero |
    | **`JG/JNLE`** | Jump Greater / Jump Not Less/Equal |
    | **`JGE/JNL`** | Jump Greater/Equal / Jump Not Less |
    | **`JL/JNGE`** | Jump Less / Jump Not Greater/Equal |
    | **`JLE/JNG`** | Jump Less/Equal / Jump Not Greater |

  * For unsigned data:
    | Instruction | Description |
    | :-: | :-: |
    | **`JE/JZ`** | Jump Equal / Jump Zero |
    | **`JNE/JNZ`** | Jump Not Equal / Jump Not Zero |
    | **`JA/JNBE`** | Jump Above / Jump Not Below/Equal |
    | **`JAE/JNB`** | Jump Above/Equal / Jump Not Below |
    | **`JB/JNAE`** | Jump Below / Jump Not Above/Equal |
    | **`JBE/JNA`** | Jump Below/Equal / Jump Not Above |

  * For special uses:
    | Instruction | Description |
    | :-: | :-: |
    | **`JXCZ`** | Jump if `CX` is Zero |
    | **`JC`** | Jump if Carry |
    | **`JNC`** | Jump if No Carry |
    | **`JO`** | Jump if Overflow |
    | **`JNO`** | Jump if No Overflow |
    | **`JP/JPE`** | Jump Parity / Jump Parity Even |
    | **`JNP/JPO`** | Jump No Parity / Jump Parity Odd |
    | **`JS`** | Jump Sign (negative value) |
    | **`JNS`** | Jump No Sign (positive value) |

### Interrupts:
* [**`INT 21h`**](https://wikidev.in/functions/assembly/8086_INT_21H): 8086 INT 21h DOS Interrupt Functions.
  * [**With `AH` = `01h`**](https://wikidev.in/wiki/assembly/8086_INT_21H/AH01h): Read character from standard input, with echo (with echo here means it will also print the character input to the standard output). The character readed will store in `AL`.
  * [**With `AH` = `09h`**](https://wikidev.in/wiki/assembly/8086_INT_21H/AH09H): Write string to standard output, the string printed is `DS:DX` until terminated string (`$`).
  * [**With `AH` = `4Ch`**](https://stanislavs.org/helppc/int_21-4c.html): Terminate process with return code.
