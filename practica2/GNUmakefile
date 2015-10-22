
# Conf. var implicitas
LEX     = flex
YACC    = bison -y
YFLAGS  = -d

# Mis variables
exes = calc

# Dependencias
calc: calc.o calc.lexer.o calc.parser.o
calc.lexer.o: calc.lexer.l
calc.parser.o: calc.parser.y


.PHONY: all clean

all: $(exes)
clean:
	$(RM) *.o $(exes)
