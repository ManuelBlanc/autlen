%{

#include <stdlib.h>
#include <stdio.h>

#include "cifrado.lexer.h"

void yyerror(const char* str);

static unsigned int N = 0;
static void decodificar_cadena(const char* str);

%}

// Estructura yylval
%union {
   char* texto;
}

// Definiciones de terminales
%token TOK_IPv4 TOK_IPv6 TOK_SEPARADOR
%token <texto> TOK_ESPACIO TOK_PALABRA

// Axioma
%start main

%%

main	: seccion1 TOK_SEPARADOR seccion2
    	;


// Contamos el numero de palabras y IPs
seccion1	: seccion1 elemento { N++; N %= 26; }
        	| seccion1 TOK_ESPACIO
        	| /* nada */
        	;

// Desciframos las palabras
seccion2	: seccion2 TOK_PALABRA { decodificar_cadena($2); free($2); }
        	| seccion2 TOK_ESPACIO { printf("%s", $2); free($2); }
        	| /* nada */
        	;


// Elementos usados en la seccion 1
elemento	: TOK_IPv4 | TOK_IPv6 | TOK_PALABRA
        	;


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

static void decodificar_cadena(const char* str) {
  while (*str) putchar(decodificar(*str++, N));
}

int yyparse(void);
void yyerror(const char* str) {
   fprintf(stderr, "yyerror: %s\n", str);
   exit(EXIT_FAILURE);
}
