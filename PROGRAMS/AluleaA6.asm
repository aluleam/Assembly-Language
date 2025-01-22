; Name: Masumbuko Alulea
; Instructor: Dr. George Hamer
; Class: CSC 314
; Assignment #: 6
; Due: Dec 2, 2024
;--------------------------------------------------------------


;---------------------------- Description ---------------------

;; Description: This program tests the MKAGCD procedure. 
;; It prompts the user for two numbers and calculates the GCD. 
;; Afterward, it asks if the user wants to calculate another GCD. 
;; The process repeats based on the user's input.

include pcmac.inc  ; Include the pcmac.inc
.model small       ; Use small memory model
.586               ; Target Intel 586 processor
.stack 100h        ; Reserve 256 bytes for stack
PUBLIC ABERTO      ; Make ABERTO procedure available to other modules



;---------------------------- Data Segment ----------------------------


EXTRN MKAGCD:NEAR   ; External GCD function

.data
    ;--------------------------------------------------------------
    ; Data Section: Input prompts, messages, and variables
    ;--------------------------------------------------------------
    numA dw ?                ; First number
    numB dw ?                ; Second number
    continue db ?            ; Continue flag (used for storing user input)
    InputA db 13, 10, "Please enter the first integer: ", '$'  ; Prompt for first number
    InputB db 13, 10, "Please enter the second integer: ", '$' ; Prompt for second number
    ContinueMsg db 13, 10, "Would you like to calculate another GCD? (Y/N): ", '$' ; Continue prompt
    gcdResultMsg db 13, 10, "The greatest common divisor (GCD) is: ", '$'  ; GCD result message
    invalidInputMsg db 13, 10, "Invalid input. Please enter Y or N.", '$' ; Invalid input message



;---------------------------- Code Segment ----------------------------

.code               ; Code section
extrn GetDec:near   ; External GetDec function
extrn PutDec:near   ; External PutDec function

ABERTO proc         ; Start of ABERTO procedure
    _Begin          ; Program start

programLoop:        ; Main loop to calculate GCD
    sub ax, ax      ; Clear AX by subtracting itself
    sub bx, bx      ; Clear BX by subtracting itself
    sub cx, cx      ; Clear CX by subtracting itself
    sub dx, dx      ; Clear DX by subtracting itself

    _PutStr InputA  ; Display prompt for first number
    call GetDec     ; Get the first number
    mov numA, ax    ; Store first number in numA

    _PutStr InputB  ; Display prompt for second number
    call GetDec     ; Get the second number
    mov numB, ax    ; Store second number in numB

    mov ax, numA    ; Load numA into AX
    mov bx, numB    ; Load numB into BX
    call MKAGCD     ; Call MKAGCD to calculate GCD

    mov cx, ax      ; Store GCD result in CX
    _PutStr gcdResultMsg    ; Display GCD result message
    mov ax, cx      ; Load GCD result into AX for display
    mov bx, cx      ; Copy result to BX for PutDec
    call PutDec     ; Print the GCD

verifyContinue:             ; Check if user wants to continue
    _PutStr ContinueMsg     ; Display continue prompt
    _GetCh                  ; Get user input
    mov continue, al        ; Store user input in 'continue'

    cmp continue, 'N'       ; Check if 'N' (No)
    je exitProgram          ; Exit program if 'N'
    cmp continue, 'n'       ; Check if 'n' (no)
    je exitProgram          ; Exit program if 'n'
    cmp continue, 'Y'       ; Check if 'Y' (Yes)
    je programLoop          ; Continue loop if 'Y'
    cmp continue, 'y'       ; Check if 'y' (yes)
    je programLoop          ; Continue loop if 'y'

    _PutStr invalidInputMsg ; Invalid input message
    jmp verifyContinue      ; Loop back to verify input again

exitProgram:                ; Exit program
    _exit 0                 ; Normal exit
ABERTO endp                 ; End of ABERTO procedure

;---------------------------- End of Program ----------------------------

END ABERTO           ; End of program
;------------------------------------------------------------------------
