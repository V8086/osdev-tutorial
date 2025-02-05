#include <stdint.h>

// entry point
extern void epboot(uint8_t disk) {
	/*
		Stop execution
		BX: BIOS disk index
		EAX: 0xababccdd
	*/
	__asm__ __volatile__("jmp ."::"a"(0xababccdd), "b"(disk));			// stop execution: BIOS disk index => bx
}