
/// cflex_sol.l
// Examen: 1
// Autor: Manuel Blanc
// Fecha: 15 octubre 2015

%{

#include <stdio.h>
#include <stdlib.h>

// Contadores de sentencias
static unsigned int acciones = 0;
static unsigned int patrones = 0;

// Contadores de metacaracteres
enum { M_RANGO, M_PUNTO, M_ASTERISCO, M_MAS, M_DISYUNCION, M_OPCIONAL, M_GUION };
static unsigned int metacaracteres[7];

/*

static struct {
	const char* nombre;
	const char *plural;
	int num;
} metacaracteres = {
	{ "rango".     	"s", 	0 },
	{ "punto".     	"s", 	0 },
	{ "asterisco". 	"s", 	0 },
	{ "mas".       	"es",	0 },
	{ "disyuncion".	"es",	0 },
	{ "opcional".  	"es",	0 },
	{ "guion".     	"es",	0 },
};

*/

void procesar_cadena(char* chr, int len);

%}

%s modo_acciones

%option noyywrap

ID_PATRON	[A-Za-z][A-Za-z_]*

%%

<INITIAL>^{ID_PATRON}[ \t]+(.|[ \t])+$	{ patrones++; procesar_cadena(yytext, yyleng);	}
<INITIAL>^"%%"$                       	{ BEGIN(modo_acciones);                       	}

<modo_acciones>^"{"{ID_PATRON}"}"	{ acciones++;	}
<modo_acciones>^"%%"$            	{ return 0;  	}


<*>.|[[:space:]] { /* nop - ignorado*/ }

%%


void procesar_cadena(char* str, int len)
{
	int i;
	for (i=0; i < len; i++) {
		char chr = str[i];
		switch (chr) {
			case '\\': i++;                             	break;
			case '"': do { i++; } while (str[i] != '"');	break;
			case '[': metacaracteres[ M_RANGO      ]++; 	break;
			case '.': metacaracteres[ M_PUNTO      ]++; 	break;
			case '*': metacaracteres[ M_ASTERISCO  ]++; 	break;
			case '+': metacaracteres[ M_MAS        ]++; 	break;
			case '|': metacaracteres[ M_DISYUNCION ]++; 	break;
			case '?': metacaracteres[ M_OPCIONAL   ]++; 	break;
			case '-': metacaracteres[ M_GUION      ]++; 	break;
			default:                                    	break;
		}
	}
}


int main(int argc, char const *argv[])
{
	if (argc >= 3) {
		const char* fichero;

		// Fichero de entrada
		fichero = argv[1];
		yyin = fopen(fichero, "r");
		if (NULL == yyin) {
			fprintf(stderr, "No se ha podido abrir el fichero %s\n", fichero);
			return 1;
		}

		// Fichero de salida
		fichero = argv[2];
		yyout = fopen(fichero, "w");
		if (NULL == yyout) {
			fprintf(stderr, "No se ha podido abrir el fichero %s\n", fichero);
			return 1;
		}
	}
	else if (argc != 1) {
		fprintf(stderr, "Modo de operacion no reconocido (%d argumentos)\n)", argc);
	}
	yylex();

	if (patrones < acciones) {
		fprintf(yyout, "CUIDADO HAY MAS ACCIONES %d QUE PATRONES %d\n", acciones, patrones);
	}
	else if (patrones > acciones) {
		fprintf(yyout, "CUIDADO TIENES QUE HABER DEFINIDO %d PATRONES SOLO DE USO INTERNO\n", patrones-acciones);
	}

	fprintf(yyout, "SE HAN USADO %d RANGO\n",     	metacaracteres[ M_RANGO      ]);
	fprintf(yyout, "SE HAN USADO %d PUNTO\n",     	metacaracteres[ M_PUNTO      ]);
	fprintf(yyout, "SE HAN USADO %d ASTERISCO\n", 	metacaracteres[ M_ASTERISCO  ]);
	fprintf(yyout, "SE HAN USADO %d MAS\n",       	metacaracteres[ M_MAS        ]);
	fprintf(yyout, "SE HAN USADO %d DISYUNCION\n",	metacaracteres[ M_DISYUNCION ]);
	fprintf(yyout, "SE HAN USADO %d OPCIONAL\n",  	metacaracteres[ M_OPCIONAL   ]);
	fprintf(yyout, "SE HAN USADO %d GUION\n",     	metacaracteres[ M_GUION      ]);

	return 0;
}
