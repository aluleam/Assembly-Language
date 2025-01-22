; Name: Masumbuko Alulea
; Class: CSC 314
; Assign: Assignment 3
; Due: 16th October 2024

; Description:
; This program gets the current date and shows it as:
; "Today's European date is: DD-MM-YYYY"
; It uses DOS Service 2Ah to get the date
; It uses PutDec to display the date

include pcmac.inc

.MODEL SMALL  ; Small memory model
.586  ; Target Intel 586 processor
.STACK 100h  ; Stack size is 256 bytes

.DATA  ; Data section

message db "Today's European date is: ", '$'  ; Text to show the date

; Variables to hold date values
month db 0  ; Store the month
day db 0  ; Store the day
year dw 0  ; Store the year

.CODE  ; Code section
extrn PutDec:near  ; Use external procedure PutDec

MK PROC  ; Start of the procedure named MK

    _Begin  ; Start the program
    _PutStr message  ; Show the message

    ; Get date using DOS Service
    mov ah, 2Ah  ; Use DOS to get the date
    int 21h  ; Interrupt call

    ; Store the date in variables
    mov [month], dh  ; Store the month in "month"
    mov [day], dl  ; Store the day in "day"
    mov [year], cx  ; Store the year in "year"

    ; Show day first (European format)
    mov dh, 0  ; Set DH to 0
    mov dl, [day]  ; Move day to DL
    mov ax, dx  ; Move DX to AX
    call PutDec  ; Show the day

    ; Show '-'
    mov ah, 2  ; Use DOS to show a character
    mov dl, '-'  ; Set DL to '-'
    int 21h  ; Show the '-'

    ; Show month
    mov dh, 0  ; Set DH to 0
    mov dl, [month]  ; Move month to DL
    mov ax, dx  ; Move DX to AX
    call PutDec  ; Show the month

    ; Show '-'
    mov ah, 2  ; Use DOS to show a character
    mov dl, '-'  ; Set DL to '-'
    int 21h  ; Show the '-'

    ; Show year
    mov ax, [year]  ; Move year to AX
    call PutDec  ; Show the year

    ; End the program
    mov ah, 4Ch  ; Use DOS to exit
    int 21h  ; Exit the program

_Exit 0  ; Exit label
MK ENDP  ; End of procedure MK

END MK  ; Start execution at MK
