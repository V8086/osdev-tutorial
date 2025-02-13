#include <stdlib.h>

static const char DIGITS[] = { '0', '1', '2','3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

char *ultoa(unsigned long ul, char *dst, int radix) {
	if (radix < 2 || radix > 16) return 0;
	if (!ul) {
		dst[0] = '0';
		dst[1] = '\0';
		return dst;
	}

	char *ptr = dst + 1;
	unsigned long ulcp = ul;
	while (ulcp /= radix) ptr++;

	*ptr-- = '\0';
	for (;ptr >= dst;) {
		*ptr-- = DIGITS[ul % radix];
		ul /= radix;
	}

	return ptr + 1;
}

char *ltoa(long l, char *dst, int radix) {
	if (radix < 2 || radix > 16) return 0;

	char *dstcp = dst;
	if (l < 0) {
		*dstcp++ = '-';
		l = -l;
	}

	ultoa((unsigned long)l, dstcp, radix);
	return dst;
}