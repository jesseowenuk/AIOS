; Tell our computer where we are in memory
[ORG 0x7C00]

; Fill the remainder of our file with 0s (apart from the last 2 bytes)
times 510 - ($ - $$) db 0

; The magic number - this tells the computer we should be bootable
dw 0xAA55