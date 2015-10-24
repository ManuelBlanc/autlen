
## Variables de configuracion
## -------------------------------------------------------------------
CFLAGS     	= -Wall
FLEX_FLAGS 	=
BISON_FLAGS	=

exes = calc

## Dependencias automaticas (.h)
## -------------------------------------------------------------------
#srcs := $(wildcard *.c)
#CFLAGS += -MMD
#-include $(srcs:.c=.d)

## Otras dependencias
## -------------------------------------------------------------------
calc: calc.o calc.lexer.o calc.parser.o
calc.lexer.o: calc.lexer.c calc.parser.h
calc.parser.o: calc.parser.c calc.lexer.h


## Pseudo-objetivos
## -------------------------------------------------------------------
.PHONY: all clean
.DEFAULT: all

all: $(exes)
clean:
	$(RM) *.o *.d *.parser.[ch] *.lexer.[ch] $(exes)


# Recetas
# -------------------------------------------------------------------
%.lexer.c %.lexer.h: %.l
	flex $(FLEX_FLAGS) --outfile=$*.lexer.c --header-file=$*.lexer.h $<
%.parser.c %.parser.h: %.y
	bison $(BISON_FLAGS) --output-file=$*.parser.c --defines=$*.parser.h $<

# Para borar las por-defecto
%.c: %.l
%.c: %.y
