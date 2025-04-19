[org 0x7C00]

start:
    mov si, welcome_message             ; Point SI pointer at the welcome message
    call print_string                   ; Call the print_string function to print it out

    ; Check if BIOS extensions are enabled - we need this to be able use LBA
    mov ah, 0x41                        ; We need to check extensions are available so we'll use 0x41
    mov bx, 0x55AA                      ; We set this in the BX register - if extensions are enabled this will be switched 
    mov dl, 0x80                        ; We'll load from the hard drive
    int 0x13                            ; Let's run the 0x13 interrupt and see what we get back

    jc err_bios_no1                     ; Jump to the err_bios_no1 label

    mov si, msg_bios_1                  ; Point the SI index at the msg_bios_1 string
    call print_string                   ; Call the print_string function to print it out

    cmp bx, 0xAA55                      ; Check to see if BX has switched successfully (final confirmation)
    jne err_bios_no2                    ; If this isn't switched - extensions aren't enabled so we have to bale

    mov si, msg_bios_2                  ; Point the SI index at the msg_bios_2 string
    call print_string                   ; Call the print_string function to print it out

end:
    jmp $       

err_bios_no1:
    mov si, msg_bios_no1                ; Point the SI index at the start of the error message
    call print_string                   ; Call the print_string function to print it out
    jmp end                             ; jump to halt the system

err_bios_no2:
    mov si, msg_bios_no2                ; Point the SI index at the start of the error message
    call print_string                   ; Call the print_string function to print it out
    jmp end                             ; jump to halt the system

print_string:
    lodsb                               ; load next character from SI register into AL register and increment to next letter
    or al, al                           ; test to see if we've reached the null character
    jz .return                          ; if we've reached the null terminating character jump to the .return label
    mov ah, 0x0E                        ; move into teletype mode
    int 0x10                            ; print the character in AL using BIOS interrupt 0x10
    jmp print_string                    ; loop back to the start of print_string

.return:
    ret                                 ; return to calling function 

welcome_message db "AIOS booting...", 13, 10, 0
msg_bios_no1 db "No BIOS Extentions (1)", 13, 10, 0
msg_bios_no2 db "No BIOS Extentions (2)", 13, 10, 0

msg_bios_1 db "BIOS extensions (1). Success", 13, 10, 0
msg_bios_2 db "BIOS extensions (2). Success", 13, 10, 0

times 510 - ($ - $$) db 0   ; Fill the remaining file apart from the last 2 bytes with 0
dw 0xAA55                   ; the magic number to tell the CPU we are indeed bootable