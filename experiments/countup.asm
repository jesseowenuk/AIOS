; countup.asm
; this assembly file will count up from 1 - 9

[org 0x7C00]

    mov cx, 9                   ; Put the number 9 into the CX register to represent the number of digits we want to print
    mov bl, 1                   ; Put the starting number into the BL register

.loop:
    mov al, bl                  ; Copy the current number into the BL register
    add al, '0'                 ; Convert the current number to ASCII (e.g. 1 -> '1') by adding 48 (or '0')
    mov ah, 0x0E                ; Enter the teletype text mode
    int 0x10                    ; Call the BIOS interrupt 0x10 to print the current character

    inc bl                      ; increment the BL register (add 1)
    loop .loop                  ; loop decrease CX register by 1 then if CX > 0 jump back to the .loop label

    jmp $                       ; loop indefinitley here

times 510 - ($ - $$) db 0       ; Fill the rest of the file with 0's leaving enough room for the 
dw 0xAA55                       ; The magic number :-)           