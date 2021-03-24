#include "map.h"

Coordinate3d point_from_index(const double *map_3d, int index, int map_size)
{
    return (Coordinate3d){
        (int)(index / map_size),
        (int)(index % map_size),
        map_3d[index]
    };
}

double min(double number1, double number2)
{
    return number1 < number2 ? number1 : number2;
}

double max(double number1, double number2)
{
    return number1 > number2 ? number1 : number2;
}

Coordinate3d vector_from_points(const Coordinate3d *A, const Coordinate3d *B)
{
    return (Coordinate3d){B->x - A->x, B->y - A->y, B->z - A->z};
}

double vectors_dot_product(const Coordinate3d *A, const Coordinate3d *B)
{
    return A->x * B->x + A->y * B->y + A->z * B->z;
}

Coordinate3d vectors_cross_product(const Coordinate3d *A, const Coordinate3d *B)
{
    return (Coordinate3d){
        A->y * B->z - A->z * B->y,
        A->z * B->x - A->x * B->z,
        A->x * B->y - A->y * B->x
    };
}

Coordinate3d plane_normal(const Coordinate3d *A, const Coordinate3d *B, const Coordinate3d *C)
{
    Coordinate3d AB = vector_from_points(A, B);
    Coordinate3d AC = vector_from_points(A, C);

    return vectors_cross_product(&AB, &AC);
}

double vector_magnitude(const Coordinate3d *vector)
{
    return sqrtf(vector->x * vector->x + vector->y * vector->y + vector->z * vector->z);
}

double vectors_cos_angle(const Coordinate3d *A, const Coordinate3d *B)
{
    return max(vectors_dot_product(A, B) / (vector_magnitude(A) * vector_magnitude(B)), 0);
}

Coordinate3d triangle_center(const Coordinate3d *A, const Coordinate3d *B, const Coordinate3d *C)
{
    return (Coordinate3d){
        (A->x + B->x + C->x) / 3,
        (A->y + B->y + C->y) / 3,
        (A->z + B->z + C->z) / 3
    };
}