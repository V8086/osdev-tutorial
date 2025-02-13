TGT_NAME=MY_OS
TGT_FILENAME=$(TGT_NAME).bin

TGT_CC=$(TARGET)-gcc
TGT_CCLD=$(TARGET)-ld
TGT_AS=nasm
TGT_EMU=qemu-system-i386

BOOTLDR_CFLAGS=-Wall -Wextra -O0 -ffreestanding -m16 -I ./include/bootldr/second-stage
BOOTLDR_LFLAGS=-O0 -ffreestanding -melf_i386 -T ./build/bootldr.ld -nostdlib -shared
EMU_FLAGS=-monitor stdio -m 1G -cpu max

BOOTLDR_CSRC=$(shell find ./src/bootldr/second-stage -name *.c)
BOOTLDR_ASMSRC=$(shell find ./src/bootldr/second-stage -name *.asm)
BOOTLDR_COBJ=$(addsuffix .bootldr16.o, $(BOOTLDR_CSRC))
BOOTLDR_ASMOBJ=$(addsuffix .bootldr16.o, $(BOOTLDR_ASMSRC))

all: build run-normal clean
debug: build run-debug clean

build: build-bootldr
	cp ./build/bootldr.bin ./build/$(TGT_FILENAME)

build-bootldr: build-bootldr-second-stage build-bootldr-first-stage

build-bootldr-second-stage:
ifneq ($(BOOTLDR_CSRC),)
	$(MAKE) $(BOOTLDR_COBJ)
endif
ifneq ($(BOOTLDR_ASMSRC),)
	$(MAKE) $(BOOTLDR_ASMOBJ)
endif
	$(TGT_CCLD) $(BOOTLDR_COBJ) $(BOOTLDR_ASMOBJ) $(BOOTLDR_LFLAGS) -o ./build/bootldr-second-stage.bin

build-bootldr-first-stage:
	$(TGT_AS) -fbin ./src/bootldr/first-stage/first-stage.asm -o ./build/bootldr.bin -I./build/

%.c.bootldr16.o:	%.c
	$(TGT_CC) -c $< $(BOOTLDR_CFLAGS) -o $@

%.asm.bootldr16.o:	%.asm
	$(TGT_AS) -felf $< -o $@

run-normal:
	$(TGT_EMU) $(EMU_FLAGS) -drive format=raw,file=./build/$(TGT_FILENAME)

run-debug:
	$(TGT_EMU) $(EMU_FLAGS) -drive format=raw,file=./build/$(TGT_FILENAME) -D ./build/dbg.txt -d cpu_reset

clean:
	rm -f ./build/dbg.txt \
		./build/bootldr.bin \
		./build/bootldr-second-stage.bin \
		$(BOOTLDR_ASMOBJ) \
		$(BOOTLDR_COBJ)