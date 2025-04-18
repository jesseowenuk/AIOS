; fake_cli.asm - a pretend cli client to explore more asm

[org 0x7C00]

.start:
    mov ah, 0x0E                        ; Move into the BIOS teletype mode
    mov si, welcome_prompt              ; Tell the SI register to point to the first character of our welcome message
    call print_string                   ; Call the print_string function

    mov si, prompt                      ; Point the SI register at the prompt
    call print_string                   ; Call the print_string function

.read_char:
    mov ah, 0x00                        ; Change into keyboard input mode
    int 0x16                            ; Call interrupt 0x16 to read keyboard input - wait for input

    mov ah, 0x0E                        ; Move back into teletype mode
    int 0x10                            ; print out the character now in AL register thanks to 0x16

    jmp .read_char                      ; Read the next character

    jmp .end                            ; If we've got here we need to end

.end:
    jmp $                               ; Halt the system here by looping indefinitley

print_string:
    lodsb                               ; load next character from SI register into AL register and increment to next letter
    or al, al                           ; test to see if we've reached the null character
    jz .return                          ; if we've reached the null terminating character jump to the .return label
    mov ah, 0x0E                        ; move into teletype mode
    int 0x10                            ; print the character in AL using BIOS interrupt 0x10
    jmp print_string                    ; loop back to the start of print_string

.return:
    ret                                 ; return to calling function

welcome_prompt  db "Welcome to AIOS", 13, 10, 0
prompt          db "> ", 0

times 510 - ($ - $$) db 0               ; Fill the remainder of the file with 0's leaving room for the 
dw 0xAA55                               ; Magic number to make us bootable