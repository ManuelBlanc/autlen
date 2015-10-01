
%{

#include <stdio.h>
#include <stdlib.h>

enum { T_FIJO, T_INFORMACION, T_TARIFPLUS, T_MOVIL, T_INTERNACIONAL, T_SOCIAL };
static int tipo_llamada_actual;

typedef struct DatosLlamada {
	char*   	nombre;
	double  	coste;
	unsigned	cuenta;
	double  	minutos;
} DatosLlamada;

// Precios (constante)
static DatosLlamada tabla_datos[] = {
	{"Fijo",         	0.038, 0, 0.0},
	{"Informacion",  	0.160, 0, 0.0},
	{"Tarifplus",    	1.005, 0, 0.0},
	{"Movil",        	0.081, 0, 0.0},
	{"Internacional",	0.450, 0, 0.0},
	{"Social",       	0.000, 0, 0.0},
	{NULL,           	0.000, 0, 0.0},
};

%}

%option noyywrap

DIGITO	[0-9]

FIJO         	9[1-9]{DIGITO}{7}
INFORMACION  	11{DIGITO}{3}
TARIFPLUS    	(803|806|807|901|902|905){DIGITO}{6}
MOVIL        	6{DIGITO}{8}
INTERNACIONAL	"+"{DIGITO}{2}({FIJO}|{MOVIL})
SOCIAL       	[01]{DIGITO}{2}
             	/**/
TELEFONO     	({FIJO}|{INFORMACION}|{TARIFPLUS}|{MOVIL}|{INTERNACIONAL}|{SOCIAL})
             	/**/
MINUTOS      	{DIGITO}+"."{DIGITO}+

%%

{FIJO}         	{ tipo_llamada_actual = T_FIJO;         	}
{INFORMACION}  	{ tipo_llamada_actual = T_INFORMACION;  	}
{TARIFPLUS}    	{ tipo_llamada_actual = T_TARIFPLUS;    	}
{MOVIL}        	{ tipo_llamada_actual = T_MOVIL;        	}
{INTERNACIONAL}	{ tipo_llamada_actual = T_INTERNACIONAL;	}
{SOCIAL}       	{ tipo_llamada_actual = T_SOCIAL;       	}

{MINUTOS}	{	tabla_datos[tipo_llamada_actual].cuenta++;
         	 	tabla_datos[tipo_llamada_actual].minutos += atof(yytext);
         	}

.|\n	{ /* noop */ }

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

	DatosLlamada* dato;
	for (dato = tabla_datos; dato->nombre; dato++) {
		printf("Tipo      : %s\n",  dato->nombre);
		printf("Llamadas  : %u\n",  dato->cuenta);
		printf("Facturado : %.3lf euros\n", dato->coste * dato->minutos);
		printf("===================================\n");
	}

	return 0;
}
