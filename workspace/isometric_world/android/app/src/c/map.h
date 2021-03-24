#ifndef _MAP_H_
#define _MAP_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define TILE_SIZE 25

typedef struct Coordinate_s {
    double x;
    double y;
} Coordinate;

typedef struct Coordinate3d_s {
    double x;
    double y;
    double z;
} Coordinate3d;

typedef struct Color_s {
    int r;
    int g;
    int b;
} Color;

typedef struct Tile_s {
    Coordinate point_a;
    Coordinate point_b;
    Coordinate point_c;
    Color color;
} Tile;

// UTILS
Coordinate3d point_from_index(const double *map_3d, int index, int map_size);
double min(double number1, double number2);
double max(double number1, double number2);
Coordinate3d vector_from_points(const Coordinate3d *A, const Coordinate3d *B);
double vectors_dot_product(const Coordinate3d *A, const Coordinate3d *B);
Coordinate3d vectors_cross_product(const Coordinate3d *A, const Coordinate3d *B);
Coordinate3d plane_normal(const Coordinate3d *A, const Coordinate3d *B, const Coordinate3d *C);
double vector_magnitude(const Coordinate3d *vector);
double vectors_cos_angle(const Coordinate3d *A, const Coordinate3d *B);
Coordinate3d triangle_center(const Coordinate3d *A, const Coordinate3d *B, const Coordinate3d *C);

#endif
