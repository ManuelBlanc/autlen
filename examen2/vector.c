
#include "vector.h"

#include <math.h>
#include <stdio.h>
#include <unistd.h>

#define C_GREEN 	"\033[1;32m"
#define C_YELLOW	"\033[1;33m"
#define C_NONE  	"\033[0m"

static void pretty_print(const char* style, const char* str)
{
	int tty = isatty(fileno(stdout));
	if (tty) printf("%s", style);
	printf("%s", str);
	if (tty) printf(C_NONE);
}

Punto punto_new(Real x, Real y)
{
	Punto p;
	p.x = x;
	p.y = y;
	return p;
}

void punto_print(Punto p)
{
	pretty_print(C_GREEN, "(");
	printf("%lf %lf", p.x, p.y);
	pretty_print(C_GREEN, ")");
}

Punto punto_min(Punto p1, Punto p2)
{
	Punto p;
	p.x = fmin(p1.x, p2.x);
	p.y = fmin(p1.y, p2.y);
	return p;
}

Punto punto_max(Punto p1, Punto p2)
{
	Punto p;
	p.x = fmax(p1.x, p2.x);
	p.y = fmax(p1.y, p2.y);
	return p;
}


Quad quad_new(Punto min, Punto max)
{
	Quad q;
	q.min = min;
	q.max = max;
	return q;
}

void quad_print(Quad q)
{
	pretty_print(C_YELLOW, "{");
	punto_print(q.min);
	pretty_print(C_YELLOW, " ");
	punto_print(q.max);
	pretty_print(C_YELLOW, "}");
}

int quad_esVacio(Quad q)
{
	return (
		q.min.x > q.max.x ||
		q.min.y > q.max.y
	);
}

int quad_contienePunto(Quad q, Punto p)
{
	return (
		(q.min.x <= p.x && p.x <= q.max.x) &&
		(q.min.y <= p.y && p.y <= q.max.y)
	);
}

Quad quad_contenedor(Quad q1, Quad q2)
{
	int vacio1 = quad_esVacio(q1);
	int vacio2 = quad_esVacio(q2);
	if (vacio1 && vacio2) return quad_new(punto_new(0, 0), punto_new(0, 0));
	if (vacio1) return q2;
	if (vacio2) return q1;

	Quad q;
	q.min = punto_min(q1.min, q2.min);
	q.max = punto_max(q1.max, q2.max);
	return q;
}


