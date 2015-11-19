
exes = vector_graph
include make.template

## Dependencias
## -------------------------------------------------------------------
vector_graph: vector_graph.o vector_graph.lexer.o vector_graph.parser.o vector.o vector.h
vector_graph.lexer.o: vector_graph.lexer.c vector_graph.parser.h vector.h
vector_graph.parser.o: vector_graph.parser.c vector_graph.lexer.h vector.h

zip: blanc_casado_manuel_bison_sem.zip
blanc_casado_manuel_bison_sem.zip: vector.c vector.h vector_graph.c vector_graph.l vector_graph.y GNUmakefile make.template

%.zip:
	zip $* $^