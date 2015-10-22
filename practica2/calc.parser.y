// calc.y -- El parser


// Estructura yylval
%union {
	long    entero;
	double  real;
}

// Definiciones de tokens
%token            exp
%token <entero>   TOK_CTE_ENTERO
%token <real>     TOK_CTE_REAL

// Operador
%left  '+' '-'
%left  '*' '/'

%%


exp	: exp '+' exp	{ printf("Suma\n");      	}
   	| exp '-' exp	{ printf("Resta\n");     	}
   	| exp '*' exp	{ printf("Producto\n");  	}
   	| exp '/' exp	{ printf("Division\n");  	}
   	| '-' exp    	{ printf("Negacion\n");  	}
   	| '(' exp ')'	{ printf("Parentesis\n");	}
   	| cte        	{ /**/                   	}
   	;

cte	: TK_CTE_REAL
   	| TK_CTE_ENTERA
   	;




%%



