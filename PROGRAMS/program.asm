.MODEL SMALL
.STACK 100h
.DATA
    Message DB 'Hello, my name is Bill Jones', 13, 10, '$'
.CODE
Hello PROC
    mov ax, @data
    mov ds, ax
    mov dx, OFFSET Message
    mov ah, 9h
    int 21h
    mov al, 0
    mov ah, 4ch
    int 21h
Hello ENDP
END Hello
