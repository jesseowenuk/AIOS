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

    ; We've got here so let's setup the disk packet structure
    mov ax, 0x9000                      ; Address where the packet will be stored
    mov es, ax                          ; Set ES to point to this address
    xor di, di                          ; DI now points to the start of the packet

    ; Set the packet size to 16 bytes (byte 0)
    mov byte [es:di], 0x10              ; Packet size - 16 bytes (0x10)
    add di, 1                           ; Move forward 1 byte

    ; Set reserved byte to 0 (byte 1)
    mov byte [es:di], 0                 ; reserved byte - always 0
    add di, 1                           ; Move forward 1 byte 

    ; Set the number of sectors to read (byte 2 - 3)
    mov word [es:di], 1                 ; 127 sectors (max)
    add di, 2                           ; Move forward 2 bytes

    ; Set the transfer buffer address (byte 4 - 7)
    mov word [es:di], 0x8000            ; Low byte of the address
    add di, 2                           ; Move forward 2 bytes
    mov word [es:di], 0x00              ; High byte of the address
    add di, 2                           ; Move forward 2 bytes

    ; Set the lower 32 bits of LBA (byte 8 - 11)
    mov dword [es:di], 1                ; LBA 1 
    add di, 4                           ; Move forward 4 bytes

    ; Set the upper 16 bits of LBA (bytes 12 - 13)
    mov word [es:di], 0                 ; LBA upper 16 bits (0x0000)
    add di, 2                           ; Move forward 2 bytes

    ; Set DI:SI to point to the Disk Address Packet in memory
    mov ax, 0x9000                      ; Load the segment address of the disk address packet
    mov ds, ax                          ; Move this into the DS segment pointer
    xor si, si                          ; Set SI to zero

    mov ah, 0x42                        ; Move into disk read mode
    mov dl, 0x80                        ; Set to read from the first hard drive
    int 0x13                            ; Call interrupt 0x13    

    ; Restore ES:DI registers to re-enable string printing
    mov ax, 0x0000                      ; Set AX to 0
    mov ds, ax                          ; Reset DS to 0
    mov es, ax                          ; Reset ES to 0
    xor di, di                          ; Reset DI to 0
    
    ; Check for errors
    jc err_disk                         ; Jump to err_disk if carry flag is set

    mov si, msg_disk                    ; Point SI to start of disk success message
    call print_string                   ; Call print_string to print it out

    ; Setup segment and jump to our kernel
    cli                                 ; Clear interrupts while we switch
    xor ax, ax                          ; Reset the AX register
    mov ds, ax                          ; Reset the DS segment register
    mov es, ax                          ; Reset the ES segment register
    mov fs, ax                          ; Reset the FS segment register
    mov gs, ax                          ; Reset the GS segment register
    mov ss, ax                          ; Reset the SS segment register
    mov sp, 0x7C00                      ; Reset stack pointer

    jmp 0x0000:0x8000

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

err_disk:
    mov si, msg_disk_err                ; Point the SI index at the start of the error message
    call print_string                   ; Call the print_string function to print it out
    jmp end                             ; jump to halt the system

print_string:
    pusha                               ; Save the registers

.print_char:
    lodsb                               ; load next character from SI register into AL register and increment to next letter
    or al, al                           ; test to see if we've reached the null character
    jz .return                          ; if we've reached the null terminating character jump to the .return label
    mov ah, 0x0E                        ; move into teletype mode
    int 0x10                            ; print the character in AL using BIOS interrupt 0x10
    jmp .print_char                     ; loop back to the start of print_char

.return:
    popa                                ; Restore the registers
    ret                                 ; return to calling function 

welcome_message db "AIOS booting...", 13, 10, 0
msg_bios_no1 db "No BIOS Extentions (1)", 13, 10, 0
msg_bios_no2 db "No BIOS Extentions (2)", 13, 10, 0
msg_disk_err db "Disk error", 13, 10, 0

msg_bios_1 db "BIOS extensions (1). Success", 13, 10, 0
msg_bios_2 db "BIOS extensions (2). Success", 13, 10, 0
msg_disk db "Disk read. Success", 13, 10, 0

times 510 - ($ - $$) db 0   ; Fill the remaining file apart from the last 2 bytes with 0
dw 0xAA55                   ; the magic number to tell the CPU we are indeed bootable