#pragma once
#ifndef TTY_H
#define TTY_H

#include "stdlib.h"

extern void __attribute__((__cdecl__)) ttyputc(char c);
void ttyputs(const char *s);
void __attribute__((__cdecl__)) ttyprintf(const char *s, ...);

#endif