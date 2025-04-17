; countdown.asm
; this assembly file will count down from 9 - 0

[org 0x7C00]

    mov ah, 0x0E                ; Enter the teletype text mode

    mov cx, 10                  ; Put the number 9 into the CX register to represent the number of digits we want to print
    mov bl, 9                   ; Put the starting number into the BL register

.loop:
    mov al, bl                  ; Copy the current number into the BL register
    add al, '0'                 ; Convert the current number to ASCII (e.g. 1 -> '1') by adding 48 (or '0')
    int 0x10                    ; Call the BIOS interrupt 0x10 to print the current character

    mov al, ' '                 ; Put a space after the letter
    int 0x10                    ; Call the BIOS interrupt 0x10 to print the current character

    dec bl                      ; decrement the BL register (subtract 1)
    loop .loop                  ; loop decrease CX register by 1 then if CX > 0 jump back to the .loop label

    jmp $                       ; loop indefinitley here

times 510 - ($ - $$) db 0       ; Fill the rest of the file with 0's leaving enough room for the 
dw 0xAA55                       ; The magic number :-)           