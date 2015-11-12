%{

// calc.y -- El parser

#include <stdlib.h>
#include <stdio.h>

#include "calc.h"
#include "calc.lexer.h"

void yyerror(const char* str);

#define OPERAR(out, in1, op, in2)                                         	\
MACRO_BODY(                                                               	\
    if (in1.tipo != -1 && in1.tipo != in2.tipo) {                         	\
        fprintf(stderr, "Type mismatch (%i != %i)\n", in1.tipo, in2.tipo);	\
        exit(EXIT_FAILURE);                                               	\
    }                                                                     	\
    out.entero = in1.entero op in2.entero;                                	\
    out.real   = in1.real   op in2.real;                                  	\
    out.tipo   = in2.tipo;                                                	\
)                                                                         	//

Numero N0 = { .tipo=-1, .entero=0, .real=0.0 };


%}


// Estructura yylval
%union {
	Numero n;
}

// Definiciones de terminales
%token <n> TOK_ENTERO TOK_REAL

// Definciones de no-terminales
%type <n> main exp

// Axioma
%start main

// Operador
%left  '+' '-'
%left  '*' '/'

%%

main	: exp { if ($1.tipo == TOK_ENTERO) printf("%li\n", $1.entero); else printf("%lf\n", $1.real); }
    	;

exp	: exp '+' exp	{ OPERAR($$, $1, +, $3);	}
   	| exp '-' exp	{ OPERAR($$, $1, -, $3);	}
   	| exp '*' exp	{ OPERAR($$, $1, *, $3);	}
   	| exp '/' exp	{ OPERAR($$, $1, /, $3);	}
   	| '+' exp    	{ OPERAR($$, N0, +, $2);	}
   	| '-' exp    	{ OPERAR($$, N0, -, $2);	}
   	| '(' exp ')'	{ $$ = $2;              	}
   	| TOK_ENTERO 	{ $$ = $1;              	}
   	| TOK_REAL   	{ $$ = $1;              	}
   	;

%%

void yyerror(const char* str) {
   fprintf(stderr, "yyerror: %s\n", str);
   exit(EXIT_FAILURE);
}
