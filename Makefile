# Output file
OUTPUT = os.img

# Tools
ASM = nasm
CC = i686-elf-gcc
OBJCOPY = i686-elf-objcopy

# Source files
BOOTLOADER_SRC = boot.asm
KERNEL_ASM = kernel.asm
KERNEL_C = kernel.c

# Compiled object files
KERNEL_ASM_OBJ = kernel_asm.o
KERNEL_C_OBJ = kernel.o

# Compiled binaries
BOOTLOADER_BIN = boot.bin
KERNEL_BIN = kernel.bin
MAIN_KERNEL = main_kernel.bin

# Default build rule if make called on its own without options
all: $(OUTPUT)

# Combine bootloader and kernel into one image
$(OUTPUT): $(BOOTLOADER_BIN) $(KERNEL_BIN) $(MAIN_KERNEL)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) $(MAIN_KERNEL) > $(OUTPUT)

# Assemble the bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(ASM) -f bin $(BOOTLOADER_SRC) -o $(BOOTLOADER_BIN)

# Assemble the assembly kernel
$(KERNEL_BIN): $(KERNEL_ASM)
	$(ASM) -f bin $(KERNEL_ASM) -o $(KERNEL_BIN)

# Assemble the kernel assembly
$(KERNEL_ASM_OBJ): $(KERNEL_ASM)
	$(ASM) -f bin $(KERNEL_SRC) -o $(KERNEL_ASM_OBJ)

# Compile the C kernel
$(KERNEL_C_OBJ): $(KERNEL_C)
	$(CC) -ffreestanding -m32 -nostdlib -c $< -o $(KERNEL_C_OBJ)

# Remove elf data from kernel.o
$(MAIN_KERNEL): $(KERNEL_C_OBJ)
	$(OBJCOPY) -j .text -O binary $(KERNEL_C_OBJ) $(MAIN_KERNEL)

# Remove the generated binaries
clean:
	rm -f $(BOOTLOADER_BIN) $(KERNEL_BIN) $(KERNEL_ASM_OBJ) $(KERNEL_C_OBJ) $(MAIN_KERNEL) $(OUTPUT)

# Run in Qemu
run:
	qemu-system-i386 -hda $(OUTPUT)