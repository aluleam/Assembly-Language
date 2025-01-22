; Name: Masumbuko Alulea
; Class: CSC 314
; Assignment: 5
; Due Date: November 13, 2024

; Description:
; This Assembly program displays a character that moves repeatedly across the screen.
; The character starts at the left edge, travels to the right edge, then returns to the left.
; Each full movement from left to right and back is counted as one trip.
; The user can specify the total number of trips for the character to complete.
; Once the user enters the number of trips, the character will begin moving and continue
; until it has completed the number of trips requested.

include pcmac.inc               
.model small                   
.586                          
.stack 100h                   

.data  
    user_char db ?                  ; stores the character to be moved on the screen
    count db ?                      ; stores the number of occurrences

    promptCharacter db "Enter a character to display: ", '$'            ; prompt for character
    promptNum db "Enter number (1-4): ", '$'                            ; prompt for number of occurrences
    errorMsg db "Invalid input. Please enter a number between 1 and 4.", '$'   ; error message

.code
extrn GetDec:near

GetCharacter proc
    _PutStr promptCharacter     ; Display character prompt
    _GetCh                      ; Read a character
    mov user_char, al           ; Store character in user_char
    ret
GetCharacter endp

; Get the number of displays from the user
GetDisplays PROC
    mov count, 0                ; Initialize count with 0
getDisplaysl:
    _PutStr promptNum           ; Display number prompt
    call GetDec                 ; Get the number from the user
    cmp ax, 1                   ; Check if less than 1
    jl invalid                  ; Jump if invalid
    cmp ax, 4                   ; Check if greater than 4
    jg invalid                  ; Jump if invalid
    mov count, al               ; Store valid count as 8-bit in count
    ret                         ; Return from procedure
invalid:
    _PutStr errorMsg            ; Display error message
    jmp getDisplaysl            ; Repeat input prompt
GetDisplays endp

; Delay the program for a short duration
Delay PROC
    push ecx                    ; Save caller's CX
    push ax                     ; Save caller's AX
    mov cx, 0FFFFh              ; Initialize delay count
LoopDelay:                      ; Start delay loop
    nop                         
    dec cx                      ; Decrement the counter
    jnz LoopDelay               ; Repeat until CX is zero
    pop ax                      ; Restore caller's AX
    pop ecx                     ; Restore caller's CX
    ret                         ; Return from Delay
Delay ENDP

; Move a character across the screen
PrintChar proc
    push ax                     ; Save AX
    push bx                     ; Save BX
    push cx                     ; Save CX
    push dx                     ; Save DX
    
    mov cl, count               ; Load occurrences into CL
printLoop:                      ; Begin the loop
    call MoveChar               ; Call MoveChar instead of printChar
    dec cl                      ; Decrement occurrences
    cmp cl, 0                   ; Check if complete
    jne printLoop               ; Repeat if not done

    pop dx                      ; Restore DX
    pop cx                      ; Restore CX
    pop bx                      ; Restore BX
    pop ax                      ; Restore AX
    ret                         ; Return from PrintChar
PrintChar endp

; Move character across the screen
MoveChar proc
    push ax                     ; Save AX
    push bx                     ; Save BX
    push cx                     ; Save CX
    push dx                     ; Save DX

    mov cx, 79                  ; Set line limit to 79
forwardLoop:                     ; Start forward movement loop
    mov dl, user_char           ; Load character to move
    _PutCh                      ; Write character to screen
    call Delay                  ; Delay for effect
    _PutCh 8                    ; Write backspace
    _PutCh 32                   ; Write space to clear character
    dec cx                      ; Decrement line counter
    jnz forwardLoop             ; Repeat until end of line

backwardLoop:                   ; Start backward movement loop
    mov dl, user_char           ; Load character to move
    _PutCh                      ; Write character to screen
    call Delay                  ; Delay for effect
    _PutCh 8                    ; Write backspace
    _PutCh 32                   ; Write space to clear character
    inc cx                      ; Increment line counter
    cmp cx, 79                  ; Compare with line limit
    jne backwardLoop            ; Repeat until start of line

    _PutCh 13                   ; Write carriage return to screen

    pop dx                      ; Restore DX
    pop cx                      ; Restore CX
    pop bx                      ; Restore BX
    pop ax                      ; Restore AX
    ret                         ; Return from procedure
MoveChar endp

ABERTO proc
    mov ax, @DATA               ; Load data segment address
    mov ds, ax                  ; Set data segment
    call GetCharacter           ; Get character input from user
    _PutCh 10                   ; Output line feed
    _PutCh 13                   ; Move to start of line
    call GetDisplays            ; Get number of displays from user
    call PrintChar              ; Move character across the screen

    int 21h                     ; Call DOS
ABERTO ENDP

END ABERTO
