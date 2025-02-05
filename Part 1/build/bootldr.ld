ENTRY(epboot);						/* entry point */
OUTPUT_ARCH(i386);
OUTPUT_FORMAT(binary);
SECTIONS {
	BASE = 0x1000;					/* base address */
	. = BASE;

	.hdr : {
		SHORT(epboot);				/* 16-bit address of entry point */
	}

	.text : {
		*(.text)
	}

	.data : {
		*(.data)
	}

	.bss : {
		*(.bss)
	}

	.rodata : {
		*(.rodata)
	}

	.nreof : {						/* padding */
		LONG(0xFFE0FFE0);
		. = ALIGN(512);
	}

	END = .;
}