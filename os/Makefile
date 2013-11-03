C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

run: all

all: os-image

os-image: boot/bootsect.bin kernel.bin
	cat $^ /dev/zero | dd status=noxfer conv=notrunc of=os-image.flp bs=512 count=2880

# Build the kernel
kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Compile C 
%.o: %.c ${HEADERS}
	gcc -m32 -ffreestanding -c $< -o $@

# Assemble kernel_entry
%.o: %.asm 
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -I 'boot/' -o $@

clean: 
	rm -fr kernel/*.o boot/*.bin drivers/*.o
