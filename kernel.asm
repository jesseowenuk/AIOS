; kernel.asm - initial kernel file

[org 0x8000]                                ; Our kernel will be loaded at 0x8000

start:
    mov ah, 0x0E                            ; Move into teletype mode
    mov si, message                         ; Point the SI pointer at the first character of message
    call print_string                       ; Call print_string to print out the message

end:
    jmp $                                   ; Halt the system by jumping here indefinitley    

print_string:
    lodsb                                   ; load the byte pointed at by the SI index into AL register
    or al, al                               ; Test to see if we're at the null character
    jz .done                                ; Return to calling code
    int 0x10                                ; Print the character using BIOS interrupt 0x10
    jmp print_string                        ; Loop back to the beginning of this function

.done:
    ret                                     ; Return to calling code

message db "Hello from the AIOS Kernel!", 13, 10, 0