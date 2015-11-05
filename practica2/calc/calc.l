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

{ENTERO}   	{ yylval.entero = strtol(yytext, NULL, 10); return TOK_ENTERO;	}
{REAL}     	{ yylval.real   = strtod(yytext, NULL);     return TOK_REAL;  	}
{OPERADOR} 	{ return *yytext;                                             	}
[[:space:]]	{ /* Ignorado */                                              	}

%%

