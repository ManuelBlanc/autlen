%{

#include <stdlib.h>
#include <stdio.h>

#include "vector.h"
#include "vector_graph.lexer.h"

void yyerror(const char* str);

// Contenedor global y funciones de validacion
static Quad contenedor;
static void guardarContenedor(Quad q);
static void validarPunto(Punto p);
static void validarQuadrilatero(Quad q);

%}

%union {
	Real 	real;
	Punto	punto;
	Quad 	quad;
}

// Definiciones de terminales
%token '<' '>' '{' '}' '(' ')'
%token <real> TOK_REAL

// Definciones de no-terminales
%type <punto> punto
%type <quad>  lista_region cuadrilatero

// Axioma
%start diagrama

%%

diagrama	: '<' lista_region '>' { guardarContenedor($2); }  '[' lista_puntos ']'
        	;

lista_region	: cuadrilatero lista_region	{ $$ = quad_contenedor($1, $2); }
            	| cuadrilatero { $$ = $1; }
            	;

cuadrilatero	: '{' punto punto '}' { $$ = quad_new($2, $3); validarQuadrilatero($$); }
            	;

lista_puntos	: punto lista_puntos	{ validarPunto($1); }
            	| punto             	{ validarPunto($1); }
            	;

punto	: '(' TOK_REAL TOK_REAL ')' { $$ = punto_new($2, $3); }

%%

static void guardarContenedor(Quad q)
{
	 contenedor = q;
	 printf("FINALMENTE MAX %lf %lf y MIN %lf %lf\n", q.max.x, q.max.y, q.min.x, q.min.y);
}

static void validarPunto(Punto p)
{
	if (!quad_contienePunto(contenedor, p)) {
		printf("ERROR ");
		punto_print(p);
		printf(" NO EN ");
		quad_print(contenedor);
		printf("\n");
	}
}

static void validarQuadrilatero(Quad q)
{
	if (quad_esVacio(q)) {
		printf("ERROR EL CUADRILATERO ");
		quad_print(q);
		printf(" ESTA MAL FORMADO\n");
	}
}

void yyerror(const char* str)
{
	fprintf(stderr, "error sintactico: %s\n", str);
	exit(EXIT_FAILURE);
}
