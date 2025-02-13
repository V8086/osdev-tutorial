#include <tty.h>
	
static char DIGITS_BUF[66];

void ttyputs(const char *s) {
	for (unsigned i = 0; s[i]; i++) ttyputc(s[i]);
}

void __attribute__((__cdecl__)) ttyprintf(const char *s, ...) {
	char nxt;
	unsigned *p = (unsigned*)&s + 1;
	for (unsigned i = 0; s[i]; i++) {
		if (s[i] == '%') {
			nxt = s[i + 1];
			if (nxt == '%') {
				i += 1;
				ttyputc('%');
			}
			else if (nxt == 's') {
				i += 1;
				ttyputs((char*)*p++);
			}
			else if (nxt == 'c') {
				i += 1;
				ttyputc((char)*p++);
			}
			else if (nxt == 'd') {
				i += 1;
				ltoa((long)*p++, DIGITS_BUF, 10);
				ttyputs(DIGITS_BUF);
			}
			else if (nxt == 'u') {
				i += 1;
				ultoa((long)*p++, DIGITS_BUF, 10);
				ttyputs(DIGITS_BUF);
			}
			else if (nxt == 'x') {
				i += 1;
				ultoa((long)*p++, DIGITS_BUF, 16);
				ttyputs(DIGITS_BUF);
			}
			else if (nxt == 'o') {
				i += 1;
				ultoa((long)*p++, DIGITS_BUF, 8);
				ttyputs(DIGITS_BUF);
			}
			else if (nxt == 'b') {
				i += 1;
				ultoa((long)*p++, DIGITS_BUF, 2);
				ttyputs(DIGITS_BUF);
			}
		}
		else ttyputc(s[i]);
	}
}
