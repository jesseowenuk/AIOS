; Tell our computer where we are in memory
[ORG 0x7C00]

; Tell BIOS to enter teletype print mode
mov ah, 0x0E

; Move the letter 'A' into the AL register
mov al, 'A'

; Call the interrupt 0x10 to ask the BIOS to print the letter in the AL register to the screen
int 0x10

; Infinite loop to stay here forever!
jmp $

; Fill the remainder of our file with 0s (apart from the last 2 bytes)
times 510 - ($ - $$) db 0

; The magic number - this tells the computer we should be bootable
dw 0xAA55