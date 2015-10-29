
%{

#include <stdio.h>
#include <stdlib.h>

#include "cifrado.parser.h"

#define DUPLICAR_CADENA() (yylval.texto = strdup(yytext))

%}

%option noyywrap
%option nounput
%option noinput

/* ALIASES */
N255   	([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])
IPv4   	{N255}"."{N255}"."{N255}"."{N255}
HEXC   	[0-9A-F]{4}
IPv6   	{HEXC}:{HEXC}:{HEXC}:{HEXC}::
palabra	[a-z]+

%%

{IPv4}      	{ return TOK_IPv4;                      	}
{IPv6}      	{ return TOK_IPv6;                      	}
{palabra}   	{ DUPLICAR_CADENA(); return TOK_PALABRA;	}
[[:space:]]+	{ DUPLICAR_CADENA(); return TOK_ESPACIO;	}
"$$"\r?\n   	{ return TOK_SEPARADOR;                 	}
.           	{ /* Ignorado */                        	}

%%
