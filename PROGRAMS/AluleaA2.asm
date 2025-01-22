; Name: Masumbuko Alulea
; Class: CSc 314
; Assign: 2
; Due: 9/23/24
;
; Description: This program displays two messages on the screen: one with my name,
; and another about the show I binged watched last summer.

.MODEL SMALL
.STACK 100h
.DATA
    NameMessage DB 'Hello, my name is Masumbuko Alulea!', 13, 10, '$'
    ShowMessage DB 'The show I binged watched last summer was Game of Thrones.', 13, 10, '$'
.CODE
Hello PROC
    ; Set up the data segment
    mov ax, @data
    mov ds, ax
    
    ; Display the name message
    mov dx, OFFSET NameMessage
    mov ah, 9h
    int 21h  ; Print the message
    
    ; Display the show message
    mov dx, OFFSET ShowMessage
    mov ah, 9h
    int 21h  ; Print the message

    ; Exit the program
    mov al, 0
    mov ah, 4ch
    int 21h
Hello ENDP
END Hello
