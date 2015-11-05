%{

// calc.y -- El parser

#include <stdlib.h>
#include <stdio.h>

#include "calc.lexer.h"

void yyerror(const char* str);

%}

// Estructura yylval
%union {
	long   entero;
	double real;
}

// Definiciones de terminales
%token <entero> TOK_ENTERO
%token <real>   TOK_REAL

// Definciones de no-terminales
%type <entero> exp_i
%type <real>   exp_r

// Axioma
%start main

// Operador
%left  '+' '-'
%left  '*' '/'

%%

main	: exp_i { printf("Resultado final (entero) : %li\n", $1);}
    	| exp_r { printf("Resultado final (real)   : %lf\n", $1);}
    	;

exp_i	: exp_i '+' exp_i	{ $$ = $1 + $3;	}
     	| exp_i '-' exp_i	{ $$ = $1 - $3;	}
     	| exp_i '*' exp_i	{ $$ = $1 * $3;	}
     	| exp_i '/' exp_i	{ $$ = $1 / $3;	}
     	| '+' exp_i      	{ $$ = +$2;    	}
     	| '-' exp_i      	{ $$ = -$2;    	}
     	| '(' exp_i ')'  	{ $$ = $2;     	}
     	| TOK_ENTERO     	{ $$ = $1;     	}
     	;

exp_r	: exp_r '+' exp_r	{ $$ = $1 + $3;	}
     	| exp_r '-' exp_r	{ $$ = $1 - $3;	}
     	| exp_r '*' exp_r	{ $$ = $1 * $3;	}
     	| exp_r '/' exp_r	{ $$ = $1 / $3;	}
     	| '+' exp_r      	{ $$ = +$2;    	}
     	| '-' exp_r      	{ $$ = -$2;    	}
     	| '(' exp_r ')'  	{ $$ = $2;     	}
     	| TOK_REAL       	{ $$ = $1;     	}
     	;


%%

void yyerror(const char* str) {
   fprintf(stderr, "yyerror: %s\n", str);
   exit(EXIT_FAILURE);
}
