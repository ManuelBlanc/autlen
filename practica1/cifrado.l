
%{

#include <stdio.h>
#include <stdlib.h>

static int N = 0;
static char decodificar(char letra_i, int N);

%}

%option noyywrap

/* ALIASES */
N255   	([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])
IPv4   	{N255}"."{N255}"."{N255}"."{N255}
HEXC   	[0-9A-F]{4}
IPv6   	{HEXC}:{HEXC}:{HEXC}:{HEXC}::
palabra	[a-z]+

/* MODOS */
%s decod

%%


<INITIAL>{IPv4}|{IPv6}|{palabra}	{ ++N; }
<INITIAL>"$$"                   	{ N %= 26; BEGIN(decod); }

<decod>{palabra} { int i; for (i=0; i < yyleng; i++) putchar(decodificar(yytext[i], N)); }
<decod>[[:space:]]+ { printf("%s", yytext); }


<*>.|[[:space:]] { /**/ }

%%

static char decodificar(char letra_i, int N)
{
	int letra_f;

	letra_f = letra_i + N;
	if (letra_f > 'z') {
		letra_f += 'a' - 'z' - 1;
	}

	return (char) letra_f;
}

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
