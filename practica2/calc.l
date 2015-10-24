%{

// calc.l -- El lexer

#include <stdlib.h>
#include "calc.parser.h"

%}

%option noyywrap
%option nounput
%option noinput


DIGITO  	[0-9]
ENTERO  	[0-9]+
REAL    	{ENTERO}"."{ENTERO}
OPERADOR	[+\-*/()]

%%

{REAL}|{ENTERO}	{ yylval.num = strtod(yytext, NULL); return TOK_CONST;	}
{OPERADOR}     	{ return *yytext;                                     	}
[[:space:]]    	{ /* Ignorado */                                      	}

%%

