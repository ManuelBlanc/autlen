
#ifndef VECTOR_H
#define VECTOR_H 1

typedef double Real;

typedef struct Punto {
	Real x, y;
} Punto;

typedef struct Quad {
	Punto min, max;
} Quad;

Punto punto_new(Real x, Real y);
void punto_print(Punto p);
Punto punto_min(Punto p1, Punto p2);
Punto punto_max(Punto p1, Punto p2);

Quad quad_new(Punto min, Punto max);
void quad_print(Quad q);
int quad_esVacio(Quad q);
int quad_contienePunto(Quad q, Punto p);
Quad quad_contenedor(Quad q1, Quad q2);


#endif /* VECTOR_H */