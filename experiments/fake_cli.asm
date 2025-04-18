; fake_cli.asm - a pretend cli client to explore more asm

[org 0x7C00]

.setup:
    mov di, input_buffer                ; Point the DI (desintation index) register at the input_buffer label

.start:
    mov ah, 0x0E                        ; Move into the BIOS teletype mode
    mov si, welcome_prompt              ; Tell the SI register to point to the first character of our welcome message
    call print_string                   ; Call the print_string function

    mov si, prompt                      ; Point the SI register at the prompt
    call print_string                   ; Call the print_string function

.read_char:
    mov ah, 0x00                        ; Change into keyboard input mode
    int 0x16                            ; Call interrupt 0x16 to read keyboard input - wait for input

    cmp al, 0x0D                        ; Compare the character entered (stored in AL register)
    je .process_command                 ; Enter hit if AL == 0x0D, if so jump to .process_command label

    mov ah, 0x0E                        ; Move back into teletype mode
    int 0x10                            ; print out the character now in AL register thanks to 0x16

    mov [di], al                        ; Move the character from the AL register into the input_buffer (pointed at by [di])
    inc di                              ; Move to the next byte in the input_buffer label

    jmp .read_char                      ; Read the next character

    jmp .end                            ; If we've got here we need to end

.end:
    jmp $                               ; Halt the system here by looping indefinitley

.process_command:
    mov ah, 0x0E                        ; Move into teletype mode
    mov al, 13                          ; put carriage return into AL register
    int 0x10                            ; print it out
    mov al, 10                          ; put line feed into AL register
    int 0x10                            ; print it out

    mov si, input_buffer                ; Point the SI at the first byte in the input_buffer
    call print_string                   ; Call print_string

    mov ah, 0x0E                        ; Move into teletype mode
    mov al, 13                          ; put carriage return into AL register
    int 0x10                            ; print it out
    mov al, 10                          ; put line feed into AL register
    int 0x10                            ; print it out

    mov si, prompt                      ; point the SI register at the fist character of the prompt
    call print_string                   ; call print_string to print it out

    ; Process commamnd here

    mov cx, 128                         ; We're going to loop 128 times
    mov di, input_buffer                ; Set the destination index to point at the input_buffer label
    mov al, 0                           ; Set AL register to 0 (we'll need this next)
    rep stosb                           ; Store AL into [DI] and repear CX times (clear the input_buffer)

    mov di, input_buffer                ; Reset the input_buffer to the first byte ready for a new command

    jmp .read_char                      ; jump back to .read_char label

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
input_buffer    times 128 db 0

times 510 - ($ - $$) db 0               ; Fill the remainder of the file with 0's leaving room for the 
dw 0xAA55                               ; Magic number to make us bootable