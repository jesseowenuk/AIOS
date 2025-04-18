# AIOS
Using ChatGPT to teach me about operating systems - take everything you see here with a pinch of salt, I'm expecting most of it not to work!

Everything here will be highly commented and commits will sometimes include errors (though I'll try to note when they do)

## Current Status
(18th April 2025 - 12:10) name_input.asm added to experiment with more keyboard input - reads in a name and prints out a hello message

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
qemu-system-i386 boot.bin
```

## Experiements
The experiements folder contains experiments which aren't part of the final product but are useful learning experiments and examples.

They are assembled and run in the same way as the main project, cd into the experiements directory and change the file names as appropriate.