;--------------------------------------------------------------
; Procedure to find the greatest common divisor (GCD)
;--------------------------------------------------------------
; Name: Masumbuko Alulea
; Instructor: Dr. George Hamer
; Class: CSC 314
; Assignment #: 6
; Due: Dec 2, 2024
;--------------------------------------------------------------

;---------------------------- Description ---------------------

; This program finds the Greatest Common Divisor (GCD) of two numbers.
; It repeatedly subtracts the smaller number from the larger one until 
; both numbers are equal. The final value is the GCD.

.model small        ; Use small memory model
.586                ; Target Intel 586 processor
.stack 100h         ; Reserve 256 bytes for stack
PUBLIC MKAGCD       ; Make MKAGCD procedure available to other modules


;---------------------------- Code Segment ----------------------------

.code        

MKAGCD PROC         ; Procedure to calculate GCD
    PUSH DX         ; Save DX register
    PUSH SI         ; Save SI register
    PUSH DI         ; Save DI register
    PUSH BP         ; Save BP register

    ;--------------------------------------------------------------
    ; Ensure AX and BX are positive (if negative, negate them)
    ;--------------------------------------------------------------
    cmp ax, 0       ; Compare AX with zero
    jg skipNegAx    ; If AX is positive, skip negation
    neg ax          ; Negate AX to make it positive
skipNegAx:          
    cmp bx, 0       ; Compare BX with zero
    jg skipNegBx    ; If BX is positive, skip negation
    neg bx          ; Negate BX to make it positive
skipNegBx:

    ;--------------------------------------------------------------
    ; Check if either AX or BX is zero, handle if true
    ;--------------------------------------------------------------
handleZeroCase:     
    cmp ax, 0       ; Check if AX is zero
    je setBX        ; If AX is zero, set GCD to BX
    cmp bx, 0       ; Check if BX is zero
    je setAx        ; If BX is zero, set GCD to AX

gcdCalLoop:         ; Start of the loop to calculate GCD
    sub dx, dx      ; Clear DX by subtracting it from itself, set DX to 0
    div bx          ; Divide AX by BX, quotient in AX, remainder in DX
    mov ax, bx      ; Move BX to AX for the next iteration
    mov bx, dx      ; Move remainder into BX for the next iteration
    cmp bx, 0       ; Compare BX remainder with zero
    jne gcdCalLoop  ; If remainder is not zero, repeat the loop
    je endGCD       ; If remainder is zero, jump to end

setAx:              ; Set GCD to AX if BX was zero
    mov ax, ax      ; Set GCD to AX
    jmp endGCD      ; Jump to end

setBX:              ; Set GCD to BX if AX was zero
    mov ax, bx      ; Set GCD to BX
    jmp endGCD      ; Jump to end


endGCD:             ; End of the GCD procedure
    ;--------------------------------------------------------------
    ; Restore registers and return from procedure
    ;--------------------------------------------------------------
    POP BP          ; Restore BP register
    POP DI          ; Restore DI register
    POP SI          ; Restore SI register
    POP DX          ; Restore DX register
    ret             ; Return from MKAGCD procedure

MKAGCD ENDP         ; End of MKAGCD procedure

end                 ; End of assembly code
;--------------------------------------------------------------
