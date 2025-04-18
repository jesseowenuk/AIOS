; Name_input.asm - experiment to read a name in and print it out

[org 0x7C00]

    mov ah, 0x0E                        ; Move into teletype mode
    mov si, prompt                      ; Set SI pointer to point at first character of prompt message

.print_prompt:
    lodsb                               ; load next character from SI register into AL register and increment to next letter
    or al, al                           ; Test to see if we're at the null character (AL or AL will equal 0 (or false) if AL is 0)
    jz .read_input                      ; jump to the .read_input label if above test results in a zero
    int 0x10                            ; Print the next character in the prompt string
    jmp .print_prompt                   ; Jump back to the start of this printing loop

.read_input:
    mov di, name_buffer                 ; DI is the register where we'll store the letters of the name
    mov cx, 50                          ; We'll loop 50 times so this is the maximum length of the string

.read_loop:
    mov ah, 0x00                        ; Move into keyboard input mode
    int 0x16                            ; Call BIOS interrupt 0x16 to read from the keyboard

    cmp al, 13                          ; Is the key entered 'enter' (ASCII 13)?
    je .done_typing                     ; If entered key is the 'enter' key jump to .done_typing label

    cmp al, 8                           ; Is the key entered the 'backspace' (ASCII 8)?
    je .handle_backspace                ; It is - so jump to the .handle_backspace label

    mov ah, 0x0E                        ; Move back into teletype mode
    int 0x10                            ; Echo the typed character to the screen with interrupt 0x10

    stosb                               ; Store the value in the AL register into the DI register and then advance this by 1
    loop .read_loop                     ; decrement the CX register and if not at 0 jump back to the start of .read_loop
    jmp .done_typing                    ; jump to the .done_typing label

.handle_backspace:
    cmp di, name_buffer                 ; Compare the DI register to the name_buffer
    jbe .read_loop                      ; If we're at or before the buffer start, ignore (jbe = jump if below or equal)

    dec di                              ; Move buffer pointer back by 1
    inc cx                              ; increment the CX register so we can access the same character slot again

    ; Erase character from the screen (move back, print space, move back again)
    mov ah, 0x0E                        ; Move back into teletype mode
    mov al, 8                           ; Move backspace character into the AL register
    int 0x10                            ; Print the backspace character (move backwards on the screen)
    mov al, ' '                         ; Put space character into the AL register
    int 0x10                            ; Print the space character out with BIOS interrupt 0x10
    mov al, 8                           ; Move backspace character into the AL register (again)
    int 0x10                            ; Print out the backspace again 

    jmp .read_loop                      ; Jump back to the start of the .read_loop

.done_typing:
    mov al, 0                           ; Add the null terminator to the AL register
    stosb                               ; Add this to the end of our string

    ; Move to a new line
    mov ah, 0x0E                        ; Move back into teletype mode
    mov al, 13                          ; 13 is ASCII for carriage return
    int 0x10                            ; print using BIOS interrupt 0x10
    mov al, 10                          ; 10 is ASCII for line feed
    int 0x10                            ; print using BIOS inteript 0x10

    mov si, hello_message               ; Explicitly point SI register at hello_message

    ; Print out the entered name
.print_message:
    lodsb                               ; load character from SI register into AL register and move to next character
    or al, al                           ; test if character is null terminator
    jz .print_name                      ; if zero jump to the .print_name label
    int 0x10                            ; print out the next character in message
    jmp .print_message                  ; jump back to the start of the .print_message loop

.print_name:
    mov si, name_buffer                 ; point the SI index at the first character in the name_buffer label

.print_chars:
    lodsb                               ; load character from SI register into AL register and move to next character
    or al, al                           ; test if character is null terminator
    jz .end                             ; is above test is null (0) jump to the .end label
    int 0x10                            ; otherwise use BIOS interrupt 0x10 to print out the next character
    jmp .print_chars                    ; jump back to the start of print_chars loop

.end:
    ; Move to a new line
    mov ah, 0x0E                        ; Move back into teletype mode
    mov al, 13                          ; 13 is ASCII for carriage return
    int 0x10                            ; print using BIOS interrupt 0x10
    mov al, 10                          ; 10 is ASCII for line feed
    int 0x10                            ; print using BIOS inteript 0x10

    jmp $                               ; halt execution by jumping here indefinitley

prompt          db "Enter your name: ", 0
hello_message   db "Hello, ", 0
name_buffer  times 51 db 0              ; Buffer for up to characters plus 0

times 510 - ($ - $$) db 0               ; Fill the remainder of the file with 0's leaving room for the 
dw 0xAA55                               ; Magic number to make us bootable
