# AIOS
Using ChatGPT to teach me about operating systems - take everything you see here with a pinch of salt, I'm expecting most of it not to work!

Everything here will be highly commented and commits will sometimes include errors (though I'll try to note when they do)

## Current Status
(17th April 2025 - 20:02) The message 'Hello from AIOS' is now printed to the screen

## To Assemble & Run
NOTE: I'm on a mac running Qemu, you will need this installed to run.

### To Assemble
In a terminal in the same directory as boot.asm run

```
nasm boot.asm -o boot.bin
```

### To Run
In a terminal in the same directory as boot.asm and the resulting boot file run

```
qemu-system-i386 boot
```