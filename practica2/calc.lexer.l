%{

// calc.l -- El lexer

#include <stdlib.h>

%}

DIGITO  	[0-9]
ENTERO  	[0-9]+
REAL    	{ENTERO}"."{ENTERO}
OPERADOR	[+\-*/()]

%%

{ENTERO}  	{ yylval.entero = strtol(yytext, NULL, 10); return TOK_CTE_ENTERO;	}
{REAL}    	{ yylval.real   = strtod(yytext, NULL);     return TOK_CTE_REAL;  	}
{OPERADOR}	{ return *yytext;                                                 	}

%%

// Aqui no hay funciones
