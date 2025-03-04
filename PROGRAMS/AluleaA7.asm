
; Name: Masumbuko Alulea
; Class: CSC 314
; Assign: Assignment 7
; Due: 18th December 2024

; Description:
; This program prompts the user to enter their full name, including their first name, 
; middle name, and last name. The program ensures that the name input is valid by 
; checking several conditions:
; 1. The input is not empty.
; 2. The input does not exceed 80 characters.
; 3. The input only contains letters, spaces, and hyphens, ensuring no numbers or special 
;    characters are present.
; 
; If the input fails any of these checks, the program will ask the user to enter the name 
; again until a valid name is provided. Once a valid name is entered, the program formats 
; and displays it in the following structure: "Last Name, First Name Middle Name".
; The program also includes an option for the user to choose whether to continue entering 
; a new name or exit the program, allowing for multiple attempts if needed.
;===========================================================================================



include pcmac.inc           ; Include pcmac.inc file
.model small                ; Set memory model to small
.586                        ; Target the Intel 586 processor
.stack 100h                 ; Set stack size to 256 bytes

.data                       ; Start of data segment
UserInput db 80 dup(?)      ; Array to store the name, max 80 characters
InputLength dw ?            ; Variable to store the length of the name

;Characters & Messages
enterKey db 13              ; ASCII code for Enter key
welcomeText db 13, 10, 
    "----------------------------------------", 13, 10, 
    "         Welcome to the Name Entry!        ", 13, 10,
    "--------------------------------------------------", 13, 10, 
    "Enter your name [ FirstName MiddleName LastName ]:", 13, 10, 
    13, 10, 
    "* No empty names, max 80 characters.", 13, 10, 
    "* Letters, spaces, and hyphens only.", 13, 10, 
    13, 10, 
    "Please enter your name below:", 13, 10, 
    "[>>>]: ", '$'

emptyNameMsg db 13, 10, 
    "=======================================", 13, 10, 
    "      Oops! Your name is empty!       ", 13, 10, 
    "=======================================", 13, 10, 
    "Please provide a valid name:", 13, 10, 
    "   * Only letters, spaces, and hyphens.", 13, 10, 
    "   * Press enter after typing.", 13, 10, 
    "Try again!", 13, 10, 
    "=======================================", 13, 10, '$'

invalidInputMsg db 13, 10, 
    "**************************************", 13, 10, 
    "   Invalid input. Please type Y or N.", 13, 10, 
    "**************************************", 13, 10, '$'

tooLong db 13, 10, 
    "**************************************", 13, 10, 
    "   Oops! Input exceeds the 80 character limit!", 13, 10, 
    "**************************************", 13, 10, '$'

promptContinue db 13, 10, 
    "---------------------------------------", 13, 10, 
    "   Do you want to continue? (Y / N): ", 13, 10, 
    "---------------------------------------", 13, 10, '$'


commaText db ", ", '$'
;=================================================================================




.code  ; Start of code segment

DisplayEnter proc
    pusha                       ; Save all registers
    _PutStr welcomeText         ; Display the welcome text message
    popa                        ; Restore all registers
    ret                         ; Return from procedure
DisplayEnter endp              ; End of DisplayEnter procedure

TooLongMessage proc
    pusha                       ; Save all registers
    _PutStr tooLong             ; Display the "too long" error message
    popa                        ; Restore all registers
    ret                         ; Return from procedure
TooLongMessage endp            ; End of TooLongMessage procedure

EmptyNameMessage proc
    pusha                       ; Save all registers
    _PutStr emptyNameMsg        ; Display the error message for an empty name
    popa                        ; Restore all registers
    ret                         ; Return from procedure
EmptyNameMessage endp          ; End of EmptyNameMessage procedure

;;PrintCommaSpace procedure prints a comma and a space
PrintCommaSpace proc
    pusha                       ; Save all registers
    _PutStr commaText           ; Print the comma and space
    popa                        ; Restore all registers
    ret                         ; Return from procedure
PrintCommaSpace endp           ; End of PrintCommaSpace procedure

GetUserInput proc
    xor cx, cx                  ; Clear cx, used as an index for the UserInput array
    lea bx, UserInput           ; Load the address of UserInputBuffer into bx
    mov [bx - 1], ' '           ; Add a space character before the start of the array
    xor al, al                  ; Clear the al register (used for input character)
    xor si, si                  ; Clear the si register (used for indexing input)
inputLoop:
    _GetCh                       ; Get a single character input from the user
    cmp al, enterKey            ; Compare input with the Enter key
    je inputComplete            ; If Enter key is pressed, jump to inputComplete

validateCharacter:              ; Validate if the character is a letter, hyphen, or space
    cmp al, ' '                 ; Check if the character is a space
    je storeInput               ; If it's a space, store it in the buffer
    cmp al, '-'                 ; Check if the character is a hyphen
    je storeInput               ; If it's a hyphen, store it in the buffer
    cmp al, 'A'                 ; Check if the character is an uppercase letter
    jl invalidCharacter         ; If the character is less than 'A', it's invalid (non-alphabetic)
    cmp al, 'Z'                 ; Check if the character is an uppercase letter
    jg checkLowerCase           ; If it's greater than 'Z', check for lowercase letters
    jmp storeInput              ; If it's a valid uppercase letter, store it

checkLowerCase:
    cmp al, 'a'                 ; Check if the character is a lowercase letter
    jl invalidCharacter         ; If the character is less than 'a', it's invalid
    cmp al, 'z'                 ; Check if the character is a lowercase letter
    jg invalidCharacter         ; If the character is greater than 'z', it's invalid
    jmp storeInput              ; If it's a valid lowercase letter, store it

invalidCharacter:
    jmp inputLoop               ; If invalid, ignore and continue input collection

storeInput:
    mov [bx + si], al           ; Store the valid character in the buffer at the current index (si)
    inc si                      ; Increment the buffer index (si) to store the next character
    inc cx                      ; Increment the character count (cx)
    cmp cx, 80                  ; Check if the buffer has reached its maximum size (80 characters)
    jge TooLongMessage          ; If the buffer is full (80 characters), jump to buffer overflow handler
    jmp inputLoop               ; Otherwise, continue collecting input

BufferOverflow:
    call TooLongMessage         ; Call the overflow handler to display an error message
inputComplete:
    mov [bx + si], '$'          ; Terminate the input buffer with the '$' symbol (null character)
    mov InputLength, cx         ; Store the input length (number of valid characters) in InputLength
    ret                         ; Return from the procedure after completing input collection

GetUserInput endp               ; End of GetUserInput procedure


FormatAndDisplayName proc
    pusha                       ; Save all registers (preserve state)
    xor si, si                  ; Initialize si to 0 for array indexing
    mov si, InputLength         ; Load the length of the user input
    dec si                      ; Decrement si to start at the last character

    lea bx, UserInput           ; Load the address of the UserInput buffer
    dec si                      ; Adjust indexing by decrementing si

    ; Check if the input is a single character
    cmp [bx + 1], '$'           ; Check if the second character is the end marker ('$')
    je displaySingleChar        ; If so, jump to handle single character input

findLastSpace:
    mov cx, si                  ; Save the current index (si) in cx
    mov al, [bx + si]           ; Load the current character from the buffer
    cmp al, ' '                 ; Check if the character is a space
    je printLastName            ; If a space is found, print the last name
    dec si                      ; Move to the previous character
    cmp si, 0                   ; Check if we've reached the start of the string
    je handleSingleWord         ; If we've reached the start, handle a single-word input
    jmp findLastSpace           ; Continue searching for a space

; Print the last name (after space)
printLastName:
    mov si, cx                  ; Start from the saved position in cx (where the space was found)
    inc si                      ; Move to the first character of the last name
printLastLoop:
    mov al, [bx + si]           ; Load the character
    _PutCh al                   ; Print the character
    call delayOutput            ; Add a small delay after each character
    inc si                      ; Move to the next character
    cmp si, InputLength         ; Check if we've reached the end of the input
    jle printLastLoop           ; Loop until the last character of the last name is printed
    _PutCh 8                    ; Print a backspace (optional, to adjust spacing)
    call printCommaSpace        ; Print a comma and space after the last name
    jmp printOtherNames         ; Jump to print the other names

displaySingleChar:
    mov al, [bx]                ; Load the first character of the input
    _PutCh al                   ; Display the character
    call delayOutput            ; Add a small delay
    jmp endNameDisplay          ; Finish displaying and exit

handleSingleWord:
    xor si, si                  ; Reset si to 0 (start from the beginning of the input)
printSingleWord:
    mov al, [bx + si]           ; Load the character from the buffer
    _PutCh al                   ; Print the character
    call delayOutput            ; Add a small delay
    add si, 1                   ; Move to the next character
    cmp si, InputLength         ; Check if we've printed all characters
    jne printSingleWord         ; Continue printing if more characters remain
    jmp endNameDisplay          ; Finish displaying the name

printOtherNames:
    xor si, si                  ; Reset si to 0 (start from the beginning of the buffer)
printOtherLoop:
    mov al, [bx + si]           ; Load the character from the buffer
    _PutCh al                   ; Print the character
    call delayOutput            ; Add a small delay
    inc si                      ; Move to the next character
    cmp si, cx                  ; Check if we've reached the last name's position
    jne printOtherLoop          ; Continue if there are more characters
    jmp endNameDisplay          ; Finish displaying all names

endNameDisplay:
    popa                        ; Restore all registers (preserve state)
    ret                         ; Return to the caller
FormatAndDisplayName endp

; Delay the program for a while (used in printing characters)
DelayOutput PROC
    pusha
    mov cx, 0FFFFh              ; Set the delay length (a fixed value)
delayLoop:
        nop                     ; No operation, just wasting cycles for delay
        dec cx                  ; Decrease the delay counter
        jnz delayLoop           ; Loop until cx reaches zero
    popa                        ; Restore registers
    ret                         ; Return from the delay procedure
DelayOutput ENDP
;=========================================================================================



;; ABERTO procedure is the main procedure that controls user input flow
ABERTO proc
    _Begin
    xor bx, bx                  ; Initialize bx to 0 for input length check

ABERTOA7:
    call DisplayEnter            ; Display prompt for the user to enter their name
    call GetUserInput            ; Call procedure to get the user's input

    ; Check if the user's input (name) is empty
    mov bx, InputLength         ; Load the length of the input into bx
    cmp bx, 0                   ; Compare the input length with 0
    jg notEmpty                 ; If the length is greater than 0, jump to notEmpty

    call EmptyNameMessage       ; If name is empty, call procedure to display error message
    jmp ContinuePromt           ; Jump to the continue prompt to ask if user wants to retry

notEmpty:
    _PutCh 10                   ; Print a newline to format the output
    call FormatAndDisplayName   ; Call procedure to format and display the entered name
    jmp ContinuePromt           ; After displaying name, prompt user to continue or exit

ContinuePromt:
    xor al, al                  ; Clear al register to prepare for the next user input
    _PutStr promptContinue      ; Display a prompt asking if the user wants to continue
    _GetCh                      ; Get a single character input from the user
    cmp al, 'N'                 ; Check if user input is 'N' 
    je exitProgram              ; If 'N', exit the program
    cmp al, 'n'                 ; Check if user input is 'n' 
    je exitProgram              ; If 'n', exit the program
    cmp al, 'Y'                 ; Check if user input is 'Y'
    je ABERTOA7                 ; If 'Y', jump back to ABERTOA7 to continue the loop
    cmp al, 'y'                 ; Check if user input is 'y'
    je ABERTOA7                 ; If 'y', jump back to ABERTOA7 to continue the loop

    _PutStr invalidInputMsg     ; If input is neither 'Y' nor 'N', display error message
    jmp ContinuePromt           ; Jump back to continue prompt to ask again for valid input

exitProgram:
    _Exit 0                     ; Exit the program with status 0

ABERTO endp                     ; End of the ABERTO procedure

End ABERTO                       ; End of the program
;===========================================================================================