%{

// bool.y -- El parser

#include <stdlib.h>
#include <stdio.h>

#include "bool.lexer.h"

void yyerror(const char* str);

typedef enum FlagsOcurrencias {
	FLAG_AND      	= 1<<1,
	FLAG_OR       	= 1<<2,
	FLAG_NAND     	= 1<<3,
	FLAG_NOR      	= 1<<4,
	FLAG_NOT      	= 1<<5,
	FLAG_CONSTANTE	= 1<<6,
	FLAG_VARIABLE 	= 1<<7,
} FlagsOcurrencias;

#define MASCARA_C0 (FLAG_CONSTANTE | FLAG_VARIABLE)            	// la expresión no contiene operadores
#define MASCARA_C1 (MASCARA_C0 | FLAG_AND | FLAG_OR | FLAG_NOT)	// 1: la expresión contiene operadores del conjunto C1 { AND, OR, NOT }
#define MASCARA_C2 (MASCARA_C0 | FLAG_NAND)                    	// 2: la expresión contiene operadores del conjunto C2 { NAND }
#define MASCARA_C3 (MASCARA_C0 | FLAG_NOR)                     	// 3: la expresión contiene operadores del conjunto C3 { NOR }

static FlagsOcurrencias ocurrencias = 0;

static void evaluar(int val);

#define YYSTYPE int

%}

// Definiciones de terminales
%token TOK_AND TOK_OR TOK_NAND TOK_NOR TOK_NOT
%token TOK_CONSTANTE TOK_VARIABLE

// Axioma
%start main

// Operador
%left TOK_AND TOK_OR TOK_NAND TOK_NOR
%right TOK_NOT

%%

main	: exp { evaluar($1); }
    	;

exp	: exp   TOK_AND    exp	{	ocurrencias |= FLAG_AND;      	/**/ $$ = $1 && $3;   	}
   	| exp   TOK_OR     exp	{	ocurrencias |= FLAG_OR;       	/**/ $$ = $1 || $3;   	}
   	| exp   TOK_NAND   exp	{	ocurrencias |= FLAG_NAND;     	/**/ $$ = !($1 && $3);	}
   	| exp   TOK_NOR    exp	{	ocurrencias |= FLAG_NOR;      	/**/ $$ = !($1 || $3);	}
   	|       TOK_NOT    exp	{	ocurrencias |= FLAG_NOT;      	/**/ $$ = !$2;        	}
   	| '('   exp        ')'	{	                              	/**/ $$ = $2;         	}
   	| TOK_CONSTANTE       	{	ocurrencias |= FLAG_CONSTANTE;	/**/ $$ = $1;         	}
   	| TOK_VARIABLE        	{	ocurrencias |= FLAG_VARIABLE; 	/**/ $$ = 0;          	}
   	;

%%

static void evaluar(int val) {

	int tipo_exp = -1;

	     if ((ocurrencias & ~MASCARA_C0) == 0) tipo_exp = 0;
	else if ((ocurrencias & ~MASCARA_C1) == 0) tipo_exp = 1;
	else if ((ocurrencias & ~MASCARA_C2) == 0) tipo_exp = 2;
	else if ((ocurrencias & ~MASCARA_C3) == 0) tipo_exp = 3;


	if (tipo_exp >= 0) {
		printf("LA EXPRESION ESTA BIEN FORMADA Y PERTENECE AL CONJUNTO %i\n", tipo_exp);
	}
	else {
		printf("LA EXPRESION ESTA MAL FORMADA\n");
	}

	putchar('\n');

	if ((ocurrencias & FLAG_VARIABLE) == 0) {
		printf("LA EXPRESION VALE %c\n", val ? 'T' : 'F');
	}
	else {
		printf("LA EXPRESION NO ES EVALUABLE\n");
	}
}

void yyerror(const char* str) {
	fprintf(stderr, "error sintactico: %s\n", str);
	exit(EXIT_FAILURE);
}
