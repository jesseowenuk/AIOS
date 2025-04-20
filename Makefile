# Name of the final bootable image
OUTPUT = os.img

# NASM assembler
ASM = nasm

# Source files
BOOTLOADER_SRC = boot.asm
KERNEL_SRC = kernel.asm

# Compiled binaries
BOOTLOADER_BIN = boot.bin
KERNEL_BIN = kernel.bin

# Default build rule if make called on it's own without options
all: $(OUTPUT)

# Combine bootloader and kernel into one image
$(OUTPUT): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $(OUTPUT)

# Assemble the source files
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(ASM) -f bin $(BOOTLOADER_SRC) -o $(BOOTLOADER_BIN)

$(KERNEL_BIN): $(KERNEL_SRC)
	$(ASM) -f bin $(KERNEL_SRC) -o $(KERNEL_BIN)

# Rempve the generated binaries
clean:
	rm -f $(BOOTLOADER_BIN) $(KERNEL_BIN) $(OUTPUT)

# Run in Qemu
run: $(OUTPUT)
	qemu-system-i386 -hda $(OUTPUT)