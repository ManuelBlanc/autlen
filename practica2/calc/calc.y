%{

// calc.y -- El parser

#include <stdlib.h>
#include <stdio.h>

#include "calc.lexer.h"

void yyerror(const char* str);

%}

// Estructura yylval
%union {
   char     id[16+1];
   double   num;
}


// Definiciones de terminales
%token <num> TOK_CONST

// Definciones de no-terminales
%type <num> main exp

// Axioma
%start main

// Operador
%left  '+' '-'
%left  '*' '/'


%%

main	: exp { printf("Resultado final: %lf\n", $1);}
    	;

exp	: exp '+' exp	{ $$ = $1 + $3;          	}
   	| exp '-' exp	{ $$ = $1 - $3;          	}
   	| exp '*' exp	{ $$ = $1 * $3;          	}
   	| exp '/' exp	{ $$ = $1 / $3; return 2;	}
   	| '+' exp    	{ $$ = + $2;             	}
   	| '-' exp    	{ $$ = - $2;             	}
   	| '(' exp ')'	{ $$ = $2;               	}
   	| TOK_CONST  	{ $$ = $1;               	}
   	;

%%

void yyerror(const char* str) {
   fprintf(stderr, "yyerror: %s\n", str);
   exit(EXIT_FAILURE);
}
