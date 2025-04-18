; arrow_keys.asm - file which detects and logs which arrow keys have been entered

[org 0x7C00]

    mov ah, 0x0E                        ; Move into teletype mode
    mov si, prompt                      ; Set SI pointer to point at first character of prompt message

.print_prompt:
    lodsb                               ; load next character from SI register into AL register and increment to next letter
    or al, al                           ; Test to see if we're at the null character (AL or AL will equal 0 (or false) if AL is 0)
    jz .read_char                       ; jump to the .read_char label if above test results in a zero
    int 0x10                            ; Print the next character in the prompt string
    jmp .print_prompt                   ; Jump back to the start of this printing loop

.read_char:
    mov ah, 0x00                        ; Change into keyboard input mode
    int 0x16                            ; Call interrupt 0x16 to read keyboard input - wait for input

    cmp al, 0x00                        ; compare AL register to 0x00 (extended key)
    jne .end                            ; jump to .end

    cmp ah, 0x4B                        ; 0x4B - means left arrow which will be in the AH register
    je .print_left                      ; Jump to .print_left label if left arrow

    cmp ah, 0x4D                        ; 0x4D - means right arrow which will be in the AH register
    je .print_right                     ; Jump to .print_left label if left arrow

    cmp ah, 0x48                        ; 0x48 - means top arrow which will be in the AH register
    je .print_up                        ; Jump to .print_up label if left arrow

    cmp ah, 0x50                        ; 0x50 - means left arrow which will be in the AH register
    je .print_down                      ; Jump to .print_down label if left arrow

    jmp .end                            ; If we've got here we need to end


.print_left:
    mov si, left_arrow                  ; point the SI register at the first character of the left_arrow message
    call print_string                   ; call the print_string function
    jmp .end                            ; Jump to .end label to clean up and start again

.print_right:
    mov si, right_arrow                 ; point the SI register at the first character of the right_arrow message
    call print_string                   ; call the print_string function
    jmp .end                            ; Jump to .end label to clean up and start again

.print_up:
    mov si, up_arrow                  ; point the SI register at the first character of the top_arrow message
    call print_string                   ; call the print_string function
    jmp .end                            ; Jump to .end label to clean up and start again

.print_down:
    mov si, down_arrow                  ; point the SI register at the first character of the down_arrow message
    call print_string                   ; call the print_string function
    jmp .end                            ; Jump to .end label to clean up and start again

.end:
    ; Move to a new line
    mov ah, 0x0E                        ; Move back into teletype mode
    mov al, 13                          ; 13 is ASCII for carriage return
    int 0x10                            ; print using BIOS interrupt 0x10
    mov al, 10                          ; 10 is ASCII for line feed
    int 0x10                            ; print using BIOS inteript 0x10

    jmp .read_char

    jmp $                               ; halt the program here by jumping indefinitley

print_string:
    lodsb                               ; load next character from SI register into AL register and increment to next letter
    or al, al                           ; test to see if we've reached the null character
    jz .return                          ; if we've reached the null terminating character jump to the .return label
    mov ah, 0x0E                        ; move into teletype mode
    int 0x10                            ; print the character in AL using BIOS interrupt 0x10
    jmp print_string                    ; loop back to the start of print_string

.return:
    ret                                 ; return to calling function


prompt              db "Please enter an arrow key: ", 0
left_arrow          db "Left arrow", 0
up_arrow            db "Up arrow", 0
right_arrow         db "Right arrow", 0
down_arrow          db "Down arrow", 0

times 510 - ($ - $$) db 0               ; Fill the remainder of the file with 0's leaving room for the 
dw 0xAA55                               ; Magic number to make us bootable