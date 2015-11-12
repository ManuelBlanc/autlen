%{

// calc.l -- El lexer

#include <stdlib.h>

#include "calc.h"
#include "calc.parser.h"

#define RETURN_TOKEN(tok) MACRO_BODY( yylval.n.tipo = (tok); return (tok); )

%}

%option noyywrap
%option nounput
%option noinput


DIGITO  	[0-9]
ENTERO  	[0-9]+
REAL    	{ENTERO}"."{ENTERO}
OPERADOR	[+\-*/()]

%%

{ENTERO}   	{ yylval.n.entero = strtol(yytext, NULL, 10); RETURN_TOKEN(TOK_ENTERO);	}
{REAL}     	{ yylval.n.real   = strtod(yytext, NULL);     RETURN_TOKEN(TOK_REAL);  	}
{OPERADOR} 	{ return *yytext;                                                      	}
[[:space:]]	{ /* Ignorado */                                                       	}

%%

