
exes = cifrado
include ../make.template

## Dependencias
## -------------------------------------------------------------------
cifrado: cifrado.o cifrado.lexer.o cifrado.parser.o
cifrado.lexer.o: cifrado.lexer.c cifrado.parser.h
cifrado.parser.o: cifrado.parser.c cifrado.lexer.h

