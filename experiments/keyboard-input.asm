[org 0x7C00]

    mov ah, 0x0E                        ; Move into teletype mode

    ; Ask the user to enter a key
    mov si, message                     ; Move the request into the SI register

.print_loop:
    lodsb                               ; load the next byte (character) from SI register into AL register and increment SI
    or al, al                           ; Check if we're at the 0 character (the null terminator)
    jz .wait_key                        ; If above is zero jump to the .wait_key label
    int 0x10                            ; Call BIOS interrupt 0x10 to orint the character
    jmp .print_loop                     ; Jump back to the beginning of the print loop

.wait_key:
    mov ah, 0x00                        ; Move the BIOS into the keyboard read function      
    int 0x16                            ; Wait for a key press - the BIOS will move the character pressed into the AL register

    mov ah, 0x0E                        ; Move back into teletype mode
    int 0x10                            ; Print out the entered character (will be sitting in the AL register for us)

    jmp $                               ; And now we hang here by looping forever

message db "Press any key: ", 0         ; Our null terminated string

times 510 - ($ - $$) db 0               ; Fill the file with 0's leaving room for the
dw 0xAA55                               ; magic number - so we know we're bootable
