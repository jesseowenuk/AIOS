; kernel.asm - initial kernel file
[org 0x100000]                               ; Our kernel will be loaded at 0x100000

setup:
    cli                                     ; Make sure interrupts are disabled
    xor ax, ax                              ; Reset AX register
    mov es, ax                              ; Reset ES segment register
    mov ss, ax                              ; Reset SS segment register
    mov di, ax                              ; Reset DI index register
    mov sp, 0x7C00                          ; set to low level in memory

    mov ax, 0x1000                          ; Set AX register to 0x1000
    mov ds, ax                              ; Set the DS segment at the same area

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