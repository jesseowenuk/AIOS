; A simple if experiment
; Change the number on line 6 to see different results

[org 0x7C00]

    mov al, 5                       ; Put the number 5 into the AL register
    cmp al, 5                       ; Compare the number 5 to the number stored in AL
    jne .skip                       ; If the number doesn't equal 5 jump to the .skip label

    mov ah, 0x0E                    ; Otherwise move into teletype mode
    mov al, 'Y'                     ; Put the character 'Y' into the AL register
    int 0x10                        ; Call the BIOS interrupt 0x10 to print it out

    jmp .done                       ; Jump to the .done label

.skip:                              ; if we've jumped to here the number isn't 5
    mov ah, 0x0E                    ; move into teletype mode
    mov al, 'N'                     ; Put the character 'N' into the AL register
    int 0x10                        ; Call the BIOS interrupt 0x10 to print it out

.done:
    jmp $                           ; jump here indefinitley so we don't run amuck

times 510 - ($ - $$) db 0           ; write loads of 0's to our file leaving enough room for the 
dw 0xAA55                           ; Magic number so we know we're bootable

