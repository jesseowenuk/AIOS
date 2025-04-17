[org 0x7C00]

    mov al, 7       ; First number
    add al, 1       ; Add 1 (now AL = 8)
                    ; Note this only works for numbers 0 - 8

    add al, '0'     ; Convert number 8 to ASCII character '8' by adding 48 to it (48 is represented by '0')

    mov ah, 0x0E    ; Enter into teletype mode
    int 0x10        ; Print out the character

    jmp $           ; Stop here by looping indefinitley


times 510 - ($ - $$) db 0   ; Fill the remaining file apart from the last 2 bytes with 0
dw 0xAA55                   ; the magic number to tell the CPU we are indeed bootable