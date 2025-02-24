FILES = ./build/kernel.asm.o ./build/kernel.o
FLAGS = -g -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all:
	nasm -f bin ./src/boot.asm -o ./bin/boot.bin
	nasm -f elf -g ./src/kernel.asm -o ./build/kernel.asm.o
	i686-elf-gcc -I./src $(FLAGS) -std=gnu99 -c ./src/kernel.c -o ./build/kernel.o
	i686-elf-ld -g -relocatable $(FILES) -o ./build/CompleteKernel.o
	i686-elf-gcc $(FLAGS) -T ./src/linkerScript.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/CompleteKernel.o

	dd if=./bin/boot.bin of=./bin/os.bin bs=512 count=1
	dd if=./bin/kernel.bin of=./bin/os.bin bs=512 seek=1 conv=notrunc
	dd if=/dev/zero of=./bin/os.bin bs=512 count=8 seek=2 conv=notrunc

clean:
	rm -f ./bin/boot.bin
	rm -f ./bin/kernel.bin
	rm -f ./bin/os.bin
	rm -f ./build/kernel.o
	rm -f ./build.kernel.asm.o
	rm -f ./build/CompleteKernel.o