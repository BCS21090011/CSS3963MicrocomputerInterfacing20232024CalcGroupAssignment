.model small
.stack 100h
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

;this proc will find sum
findSum proc
	mov ax, num1
	add ax, num2
	mov val, ax
	mov ah,09h
	mov dx, offset outputMsg 
	int 21h
	call displayNumber
ret
findSum endp

;this proc will find sub
findSub proc
	mov ax, num1
	sub ax, num2
	mov val, ax
	mov ah,09h
	mov dx, offset outputMsg 
	int 21h
	call displayNumber
ret
findSub endp

; Procedure to calculate the factorial of a number
; Assumes num1 contains the number for which to calculate the factorial
; Result will be stored in val
findFactorial proc
    mov cx, num1     ; Load the number into CX, which will serve as our counter
    mov ax, 1        ; Initialize AX with 1, as the factorial result will be stored here
    cmp cx, 0        ; Compare CX with 0 to handle the special case of 0!
    JE factorialDone ; If CX is 0, jump to factorialDone (0! = 1)

factorialLoop:
    mul cx           ; Multiply AX by CX (AX = AX * CX), AX initially 1
    loop factorialLoop ; Decrease CX by 1 and repeat the loop if CX != 0

factorialDone:
    mov val, ax      ; Store the result in val
	ret
findFactorial endp


;this proc will find mul
findMul proc
	mov ax, num1
	mov bx, num2
	mov dx,0
	mul bx
	mov val, ax
	mov ah,09h
	mov dx, offset outputMsg 
	int 21h
	call displayNumber
ret
findMul endp

;this proc will find modulus
findMud proc
    mov ax, num1            ; Load first number into AX
    xor dx, dx              ; Clear DX to hold the remainder after division
    div num2                ; AX divided by num2, quotient in AX, remainder in DX
    mov val, dx             ; Move the remainder (modulus result) into 'val'
    mov ah,09h
    mov dx, offset outputMsg; Prepare to display "Result = $"
    int 21h
    call displayNumber      ; Display the result stored in 'val'
ret              ; Return to start for next operation
findMud endp


;this proc will find div
findDiv proc
	mov ax, num1
	mov bx, num2
	mov dx, 0
	div bx
	mov val, ax
	mov ah,09h
	mov dx, offset outputMsg 
	int 21h
	call displayNumber
ret
findDiv endp

findPower proc
    mov ax, num1    ; AX will hold the result, start with base.
    mov cx, num2    ; CX will be the counter, start with exponent.
    test cx, cx ; Test if exponent is 0.
    jz setToOne ; If exponent is 0, jump to set result to 1.
    dec cx  ; Decrement CX as it starts from exponent - 1.
    jz endPower ; If num2 was 1, it is done.
powerLoop:
    mul num1    ; Multiply AX by num1, result in DX:AX, will only take AX.
    loop powerLoop  ; Loop until CX is 0.
    jmp endPower    ; Jump to endPower, bypassing setToOne.

setToOne:
    mov ax, 1   ; Directly set ax to 1 for the case num1 ** 0.
    ; Skip the loop and go directly to storing the result.

endPower:
    mov val, ax ; Store result n val for displaying.
    mov ah,09h
	mov dx, offset outputMsg 
	int 21h
	call displayNumber
    ret
findPower endp

;this proc will take input from user and store value in val variable
inputNumber proc
    
    mov val,0
    mov ax,0
again: 
    mov val,ax
    mov ah,01h
    int 21h
    cmp al,0dh
    JE endLoop
    cmp al,' '
    JE endLoop
    cmp al,'0'
    JB inv
    cmp al,'9'
    JA inv
    JMP store
inv:   
	
	call printNewLine
	mov ah,09h
	mov dx,offset invalidMsg
	int 21h
	mov val,0
	mov ax, 0
	JMP again
    JMP endLoop
store:
    sub al,30h
    mov ch,al
    mov cl,10
    mov ax,val
    mul cl
    mov cl,ch
    mov ch,0
    add ax,cx
    mov val,ax
    JMP again
endLoop:

    ret
inputNumber endp


;this proc  will display the number in decimal
displayNumber proc 
	
	push ax
	push bx
	push cx
	push dx
	
	mov ax, val
	cmp ax, 0
	JNL lab
	not ax
	add ax, 1
	mov val, ax
	mov ah, 02h
	mov dl, '-'
	int 21h
	
lab:
	mov counter,0						; counter = no of digitst in num, set no of digit = 0
	mov bx,10							
	mov ax,val							; save value in ax
	cmp ax,0							; if num is zero, then print 0 and exit
	JNE saveDigit						; if num is not zero then save digit
	mov ah,02h		
	mov dl,'0'	
	int 21h
	JMP stopPrint						; if val = 0 , then display zero only and exit						
saveDigit:
	cmp ax,0							; stop when val become zero or less mean when ax<0					
	JBE stopSaveDigit 
	mov dx,0							; set dx=0
	div bx								; div ax by bx, divide number by base 
	push dx								; remainder will save on dx, we will push it on stack	
	inc counter							; inc counter, increase the no of digits	
	JMP saveDigit						; save next digit
stopSaveDigit:
	
	mov cl,1							;loop counter cl =1
startPrint:
	cmp cl,counter						;check if cl > no of digitst , then stop printing the digit
	JA stopPrint						
	mov ah,02h					
	pop dx	
	add dl,'0'							; digit to character
	int 21h
	inc cl								; inc the loop counter
	JMP startPrint						; print next digit
stopPrint:								;stop print
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
displayNumber endp

; this proc will display new line
printNewLine proc
	mov ah,09h
	mov dx, offset newLine
	int 21h
	ret
printNewLine endp

end main