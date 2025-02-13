#include <stdint.h>
#include <tty.h>

// entry point
extern void epboot(uint8_t disk) {
	ttyputs("Welcome to the second stage of the bootloader!\r\n");
	ttyprintf("Disk you booted from: %xh\r\n", disk);
	
	__asm__ __volatile__("jmp .");			// stop execution
}