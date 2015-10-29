
exes = calc
include ../make.template

## Dependencias
## -------------------------------------------------------------------
calc: calc.o calc.lexer.o calc.parser.o
calc.lexer.o: calc.lexer.c calc.parser.h
calc.parser.o: calc.parser.c calc.lexer.h

