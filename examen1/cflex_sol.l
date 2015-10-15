%{
/// cflex_sol.l
// Examen: 1
// Autor: Manuel Blanc
// Fecha: 15 octubre 2015


#include <stdio.h>
#include <stdlib.h>

#if 0
#  define ROJO(str)	"\033[31m" str "\033[0m"
#else
#  define ROJO(str)	str
#endif

// Contadores de sentencias
static unsigned int acciones = 0;
static unsigned int patrones = 0;

// Contadores de metacaracteres
enum { M_RANGO, M_PUNTO, M_ASTERISCO, M_MAS, M_DISYUNCION, M_OPCIONAL, M_GUION, _M_LEN };
static struct {
	const char* nombre;
	const char *plural;
	int num;
} metacaracteres[_M_LEN] = {
	{ "rango",     	"s", 	0 },
	{ "punto",     	"s", 	0 },
	{ "asterisco", 	"s", 	0 },
	{ "mas",       	"es",	0 },
	{ "disyuncion",	"es",	0 },
	{ "opcional",  	"es",	0 },
	{ "guion",     	"es",	0 },
};

// Funcion auxiliar
static void contar_metacaracteres_en_patron(char* chr, int len);

%}

%s modo_acciones
%option noyywrap

ID_PATRON	[A-Za-z][A-Za-z_]*

%%

  /* Bloque de patrones */
<INITIAL>^{ID_PATRON}[ \t]+(.|[ \t])+$	{ patrones++; contar_metacaracteres_en_patron(yytext, yyleng);	}
<INITIAL>^"%%"$                       	{ BEGIN(modo_acciones);                                       	}

  /* Bloque de acciones */
<modo_acciones>^"{"{ID_PATRON}"}"	{ acciones++;	}
<modo_acciones>^"%%"$            	{ return 0;  	}

  /* Ignoramos los caracteres que no reconocemos */
<*>.|[[:space:]] { /* nop - ignorado*/ }

%%


static void contar_metacaracteres_en_patron(char* str, int len)
{
	int i;
	for (i=0; i < len; i++) {
		char chr = str[i];
		switch (chr) {
			case '\\': i++;                                	break;
			case '"': do { i++; } while (str[i] != '"');   	break;
			case '[': metacaracteres[ M_RANGO      ].num++;	break;
			case '.': metacaracteres[ M_PUNTO      ].num++;	break;
			case '*': metacaracteres[ M_ASTERISCO  ].num++;	break;
			case '+': metacaracteres[ M_MAS        ].num++;	break;
			case '|': metacaracteres[ M_DISYUNCION ].num++;	break;
			case '?': metacaracteres[ M_OPCIONAL   ].num++;	break;
			case '-': metacaracteres[ M_GUION      ].num++;	break;
			default:                                       	break;
		}
	}
}


int main(int argc, char const *argv[])
{
	argc--;
	// Si tenemos mas de 2 argumentos abrimos los dos ficheros especificados
	if (argc >= 2) {
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
	// En caso contrario, debemos tener 0 argumentos (excluimos el caso de 1 argumento)
	else if (argc != 0) {
		fprintf(stderr, "Modo de operacion no reconocido (%d argumentos)\n)", argc);
	}

	// Procesamos la entrada
	yylex();

	// Informamos al usuario
	if (patrones < acciones) {
		fprintf(yyout, "CUIDADO HAY MAS ACCIONES %d QUE PATRONES %d\n\n", acciones, patrones);
	}
	else if (patrones > acciones) {
		fprintf(yyout, "CUIDADO TIENES QUE HABER DEFINIDO %d PATRONES SOLO DE USO INTERNO\n\n", patrones-acciones);
	}


	// Imprimimos cuantos hay de cada metacaracter
	int i;
	for (i=0; i < _M_LEN; i++){
		int num = metacaracteres[i].num;
		if (num > 0) {
			int es_plural = (num >= 2);
			fprintf(yyout, "Se ha%s usado " ROJO("%d") " %s%s.\n",
				es_plural ? "n" : "",
				num,
				metacaracteres[i].nombre,
				es_plural ? metacaracteres[i].plural : ""
			);
		}
	}

	return 0;
}
