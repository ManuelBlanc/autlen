
%{

#include <stdio.h>
#include <stdlib.h>

%}

%option noyywrap

DIGITO       	[0-9]
NATURAL      	{DIGITO}+
SIGNO        	[+-]
REAL         	{SIGNO}?{NATURAL}('.'{NATURAL})?
PALABRACLAVE 	si|entonces|otro_caso|mientras|repetir|leer|escribir|subprograma
IDENTIFICADOR	[[:alpha:]][[:alnum:]_@¡!]*
OPERADOR     	[|*/+\-&<>=]
ESPACIO      	[[:space:]]+

%%

{NATURAL}      	{ printf("<NATURAL>       :: %s\n", yytext);	}
{REAL}         	{ printf("<REAL>          :: %s\n", yytext);	}
{PALABRACLAVE} 	{ printf("<PALABRACLAVE>  :: %s\n", yytext);	}
{IDENTIFICADOR}	{ printf("<IDENTIFICADOR> :: %s\n", yytext);	}
{OPERADOR}     	{ printf("<OPERADOR>      :: %s\n", yytext);	}
{ESPACIO}      	{ /* Ignorado */                            	}
.              	{ printf("incorrecto: %s\n", yytext);       	}

%%

int main(int argc, char const *argv[])
{
	const char* fichero = "stdin";
	if (argc >= 2) {
		fichero = argv[1];
		yyin = fopen(fichero, "r");
		if (NULL == yyin) {
			fprintf(stderr, "No se ha podido abrir el fichero %s\n", fichero);
			return 1;
		}
	}
	yylex();

	return 0;
}
