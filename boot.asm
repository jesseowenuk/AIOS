[ORG 0x7C00]                    ; Tell our computer where we are in memory

    mov si, hello_message       ; Sets SI pointer to the first letter of our message


.loop:                          ; The start of a loop
    lodsb                       ; Loads SI (first letter of our message) into AL, then moves SI onto the next letter
    cmp al, 0                   ; Do a test to see if AL register is equal to 0
    je .done                    ; If test above is true - we've reached the end of the message so jump to the .done label

    mov ah, 0x0E                ; Otherwise enter into teletype mode
    int 0x10                    ; Call interrupt 0x10 to print the character in the AL register
    jmp .loop                   ; Jump back to the .loop label to print the next character in the message

.done:                          ; The done label - we'll jump here once the message has been printed
    jmp $                       ; And now we'll loop forever

; This is our message to print - it has to end with a 0 to say it's the end of the message
; db means define byte - it stores our message and identifies this location with hello_message
hello_message db 'Hello from AIOS', 0

; Fill the remainder of our file with 0s (apart from the last 2 bytes)
times 510 - ($ - $$) db 0

; The magic number - this tells the computer we should be bootable
dw 0xAA55