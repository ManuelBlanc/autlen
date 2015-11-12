
#ifndef CALC_H
#define CALC_H

#define MACRO_BODY(body) do { body}  while (0)

typedef struct Numero {
	int    tipo;

	long   entero;
	double real;
} Numero;

#endif
