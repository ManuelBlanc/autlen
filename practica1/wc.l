
%{
#include <stdio.h>
static unsigned int palabras = 0;
static unsigned int lineas   = 0;
static unsigned int bytes    = 0;
%}

%option noyywrap

ESPACIO [ \t\n]

%%

[^ \t\n]+	{ ++palabras; bytes += yyleng; }
\n       	{ ++lineas; ++bytes; }
.        	{ ++bytes; }

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

	printf(" %u %u %u %s\n", lineas, palabras, bytes, fichero);

	return 0;
}
