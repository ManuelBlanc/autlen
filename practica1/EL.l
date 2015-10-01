
%{
#include <stdio.h>
%}

%option noyywrap

ARTICULO	(?i:el|la|los|las)
NALPHA  	[^[:alpha:]]

%%

{ARTICULO}	{ int i; for (i=0; i < yyleng; i++) putchar(toupper(yytext[i])); }

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
