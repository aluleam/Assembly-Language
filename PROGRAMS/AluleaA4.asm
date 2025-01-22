;; Name: Conversion of Fahrenheit to Celsius 
;; Class: CSC 314
;; Assign: Assignment 4
;; Due: 30th October 2024


;; This program converts Fahrenheit temperatures to Celsius.
;; It prompts the user to enter a temperature in Fahrenheit.
;; The conversion is done using the formula:
;; Celsius = (5/9) * (Fahrenheit - 32)
;; 
;; Steps:
;; 1. Display a message asking the user to enter a Fahrenheit temperature.
;; 2. Read the input value and store it.
;; 3. Subtract 32 from the input temperature.
;; 4. Multiply the result by 5.
;; 5. Divide the result by 9 to get the Celsius temperature.
;; 6. Display the converted temperature in Celsius as an integer.


include pcmac.inc         ; Include necessary macros
.model small              ; Set memory model to small
.586                      ; Enable 32-bit instructions
.stack 100h               ; Set stack size to 256 bytes

.data
input_msg db "Enter temperature in Fahrenheit: ", '$'    ; Message to prompt user for input
output_msg db "The temperature in Celsius is: ", '$'        ; Message to display output
fahrenheit dw 0                                           ; Variable to store Fahrenheit input
celsius dw 0                                              ; Variable to store Celsius output

.CODE
extrn PutDec:near       ; Function to print decimal values
extrn GetDec:near       ; Function to read decimal values

ABERTO PROC
    _Begin                    ; Start main procedure
    _PutStr input_msg         ; Show input message
    call GetDec               ; Get input from user and store in AX
    mov fahrenheit, ax        ; Store input in fahrenheit variable

    _PutStr output_msg        ; Show output message

    mov ax, fahrenheit        ; Load Fahrenheit input into AX
    sub ax, 32                ; Subtract 32 from Fahrenheit

    mov bx, 5                 ; Set BX to 5 for multiplication
    mov cx, 9                 ; Set CX to 9 for division
    mov dx, 0                 ; Clear DX for division

    imul ax, bx               ; Multiply (Fahrenheit - 32) by 5
    idiv cx                   ; Divide the result by 9

    mov celsius, ax           ; Store the Celsius result
    call PutDec               ; Print the Celsius value

    _Exit 0                   ; Exit program
ABERTO endp

End ABERTO                  ; End of program
