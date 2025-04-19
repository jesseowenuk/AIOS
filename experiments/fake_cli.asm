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

    mov si, prompt                      ; point the SI register at the fist character of the prompt
    call print_string                   ; call print_string to print it out

    mov si, input_buffer                ; Point SI pointer at first character of input_buffer
    mov di, cmd_help                    ; Point DI pointer at first character of cmd_help
    call compare_input                  ; Call compare_input function
    cmp al, 1                           ; We have a match if compare_input returns a 1
    je .handle_help                      ; Jump to handle_help label

    mov si, input_buffer                ; Point SI pointer at first character of input_buffer
    mov di, cmd_echo                    ; Point DI pointer at first character of cmd_echo
    call compare_input                  ; Call compare_input function
    cmp al, 1                           ; We have a match if compare_input returns a 1
    je .handle_echo                     ; Jump to handle_echo label

    mov si, input_buffer                ; Point SI pointer at first character of input_buffer
    mov di, cmd_about                   ; Point DI pointer at first character of cmd_about
    call compare_input                  ; Call compare_input function
    cmp al, 1                           ; We have a match if compare_input returns a 1
    je .handle_about                    ; Jump to handle_about label

    mov si, msg_unknown                 ; Point the SI index at msg_unknown
    call print_string                   ; Call print_string to print out unknown command message

    mov cx, 128                         ; We're going to loop 128 times
    mov di, input_buffer                ; Set the destination index to point at the input_buffer label
    mov al, 0                           ; Set AL register to 0 (we'll need this next)
    rep stosb                           ; Store AL into [DI] and repear CX times (clear the input_buffer)

    mov di, input_buffer                ; Reset the input_buffer to the first byte ready for a new command
    jmp .read_char                      ; Jump back to .read_char label

.handle_help:
    mov si, msg_help                    ; Point the SI index at msg_help
    call print_string                   ; Call print_string function to print out help message

    mov cx, 128                         ; We're going to loop 128 times
    mov di, input_buffer                ; Set the destination index to point at the input_buffer label
    mov al, 0                           ; Set AL register to 0 (we'll need this next)
    rep stosb                           ; Store AL into [DI] and repear CX times (clear the input_buffer)

    mov di, input_buffer                ; Reset the input_buffer to the first byte ready for a new command
    jmp .read_char                      ; Jump back to .read_char label

.handle_echo:
    mov si, msg_echo                    ; Point the SI index at msg_echo
    call print_string                   ; Call print_string function to print out echo message

    mov cx, 128                         ; We're going to loop 128 times
    mov di, input_buffer                ; Set the destination index to point at the input_buffer label
    mov al, 0                           ; Set AL register to 0 (we'll need this next)
    rep stosb                           ; Store AL into [DI] and repear CX times (clear the input_buffer)

    mov di, input_buffer                ; Reset the input_buffer to the first byte ready for a new command
    jmp .read_char                      ; Jump back to .read_char label

.handle_about:
    mov si, msg_about                   ; Point the SI index at msg_about
    call print_string                   ; Call print_string function to print out about message

    mov cx, 128                         ; We're going to loop 128 times
    mov di, input_buffer                ; Set the destination index to point at the input_buffer label
    mov al, 0                           ; Set AL register to 0 (we'll need this next)
    rep stosb                           ; Store AL into [DI] and repear CX times (clear the input_buffer)

    mov di, input_buffer                ; Reset the input_buffer to the first byte ready for a new command
    jmp .read_char                      ; Jump back to .read_char label

print_string:
    lodsb                               ; load next character from SI register into AL register and increment to next letter
    or al, al                           ; test to see if we've reached the null character
    jz .return                          ; if we've reached the null terminating character jump to the .return label
    mov ah, 0x0E                        ; move into teletype mode
    int 0x10                            ; print the character in AL using BIOS interrupt 0x10
    jmp print_string                    ; loop back to the start of print_string

.return:
    ret                                 ; return to calling function

compare_input:
    push si                             ; Save SI register so we can use it on return
    push di                             ; Save DI register so we can use it on return

.next_char:
    lodsb                               ; Load byte from [SI] into AL, increment SI to next byte
    cmp al, [di]                        ; Compare the byte pointed at by the DI register withe one currently in the AL register
    jne .not_matched                    ; If they're not equal we have not matched - so jump to the .not_matched label
    cmp al, 0                           ; Now check to make sure AL register does not have the null character
    je .matched                         ; If it does jump to the .matched label
    inc di                              ; Increment the DI pointer to the next byte (so after lodsb runs they will pointing at the same byte in each word to compare)
    jmp .next_char                      ; Go back to the beginning of the loop to read and compare the next character

.matched:
    ; Strings are equal so....
    mov al, 1                           ; Return 1 = match
    pop di                              ; Restore the DI pointer
    pop si                              ; Restore the SI pointer
    ret                                 ; Return to the calling code

.not_matched:
    ; Strings are not equal so....
    mov al, 0                           ; Return 0 - no match
    pop di                              ; Restore the DI pointer
    pop si                              ; Restoe the SI pointer
    ret                                 ; Return to the calling code

welcome_prompt  db "Welcome to AIOS", 13, 10, 0
prompt          db "> ", 0
input_buffer    times 128 db 0

cmd_help        db "help", 0
cmd_echo        db "echo", 0
cmd_about       db "about", 0

msg_help        db "Available commands: echo, help, about", 13, 10, 0
msg_echo        db "Echoes any string passed to it e.g. echo hello will print hello", 13, 10, 0
msg_about       db "Gives information about Fake CLI", 13, 10, 0
msg_unknown     db "Unknowm command", 13, 10, 0


times 510 - ($ - $$) db 0               ; Fill the remainder of the file with 0's leaving room for the 
dw 0xAA55                               ; Magic number to make us bootable