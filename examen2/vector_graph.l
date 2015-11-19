%{

#include <stdlib.h>

#include "vector.h"
#include "vector_graph.parser.h"

%}

%option noyywrap
%option nounput
%option noinput

SIGNO  	[+-]?
NATURAL	[0-9]+
REAL   	{SIGNO}{NATURAL}(\.{NATURAL})?

%%

{REAL}      	{ yylval.real = strtod(yytext, NULL); return TOK_REAL;                                                           	}
[(){}<>\[\]]	{ return yytext[0];                                                                                              	}
[[:space:]] 	{ /* Ignorado */                                                                                                 	}
.           	{ fprintf(stderr, "error lexico: Caracter no reconocido ('%c', %i)\n", yytext[0], yytext[0]); exit(EXIT_FAILURE);	}

%%
