%{

// bool.l -- El lexer

#include <stdlib.h>

#include "bool.parser.h"

%}

%option noyywrap
%option nounput
%option noinput

%%

T|F        	{ yylval = (yytext[0] == 'T'); return TOK_CONSTANTE;                                                             	}
AND        	{ return TOK_AND;                                                                                                	}
OR         	{ return TOK_OR;                                                                                                 	}
NAND       	{ return TOK_NAND;                                                                                               	}
NOR        	{ return TOK_NOR;                                                                                                	}
NOT        	{ return TOK_NOT;                                                                                                	}
"("|")"    	{ return yytext[0];                                                                                              	}
[a-z]+     	{ return TOK_VARIABLE;                                                                                           	}
[[:space:]]	{ /* Ignorado */                                                                                                 	}
.          	{ fprintf(stderr, "error lexico: Caracter no reconocido ('%c', %i)\n", yytext[0], yytext[0]); exit(EXIT_FAILURE);	}

%%
