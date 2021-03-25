#include "map.h"

double *create_3d_map(int map_size)
{
    double *map_3d = malloc(sizeof(double) * map_size * map_size);

    for (int i = 0; i < map_size * map_size; i++) {
        map_3d[i] = perlin((int)(i / map_size) * 0.15, (int)(i % map_size) * 0.15) * 3;
    }
    return map_3d;
}

Coordinate *create_2d_map(const double *map_3d, int map_size)
{
    Coordinate *map_2d = malloc(sizeof(Coordinate) * map_size * map_size);
    Coordinate3d point;

    for (int i = 0; i < map_size * map_size; i++) {
        point = point_from_index(map_3d, i, map_size);
        point.x *= TILE_SIZE;
        point.y *= TILE_SIZE;
        point.z *= TILE_SIZE;

        map_2d[i].x = cos(0.4) * point.x - cos(0.4) * point.y;
        map_2d[i].y = sin(0.5) * point.y + sin(0.5) * point.x - point.z;
    }
    return map_2d;
}

int get_extrem_point_index(const double *map_3d, int square[4])
{
    int extreme_index = 0;
    double extreme_dif = 0.0;
    double extreme_dif_tmp = 0.0;
    double average;
    
    if (map_3d[square[0]] == map_3d[square[1]] && 
        map_3d[square[0]] == map_3d[square[2]] &&
        map_3d[square[0]] == map_3d[square[3]]) {
        return 0;
    }
    average = (map_3d[square[0]] + map_3d[square[1]] +
               map_3d[square[2]] + map_3d[square[3]]) / 4;

    for (int i = 0; i < 4; i++) {
        extreme_dif_tmp = average - map_3d[square[i]];
        extreme_dif_tmp = extreme_dif_tmp < 0 ? -extreme_dif_tmp : extreme_dif_tmp;
        if (extreme_dif_tmp > extreme_dif) {
            extreme_dif = extreme_dif_tmp;
            extreme_index = i;
        }
    }
    return extreme_index;
}

float get_diffuse_light(Coordinate3d *tile_center, Coordinate3d *A, Coordinate3d *B, Coordinate3d *C)
{
    Coordinate3d normal = plane_normal(C, B, A);
    Coordinate3d sun = (Coordinate3d){20, 13, 6};
    Coordinate3d light = vector_from_points(tile_center, &sun);

    return vectors_cos_angle(&normal, &light);
}

Color tile_color(double light, double high)
{
    Color color = {255, 255, 255};

    if (high < -0.6) {
        color = (Color){155, 255, 255};
    } else if (high < -0.25) {
        color = (Color){255, 255, 30};
    } else if (high < 0.55) {
        color = (Color){66, 255, 66};
    } else if (high < 1.25) {
        color = (Color){128, 128, 128};
    }
    return (Color){floor(color.r * light), floor(color.g * light), floor(color.b * light)};
}

Tile create_tile(const double *map_3d, const Coordinate *map_2d, int map_size, int index_a, int index_b, int index_c)
{
    Coordinate3d A = point_from_index(map_3d, index_a, map_size);
    Coordinate3d B = point_from_index(map_3d, index_b, map_size);
    Coordinate3d C = point_from_index(map_3d, index_c, map_size);

    Coordinate3d tile_center = triangle_center(&A, &B, &C);

    double diffuse_light = get_diffuse_light(&tile_center, &A, &B, &C);
    double ambiant_light = 0.3;
    double light = min(ambiant_light + diffuse_light, 1.0);

    Color color = tile_color(light, tile_center.z);

    return (Tile){map_2d[index_a], map_2d[index_b], map_2d[index_c], color};
}

Tile *create_tile_map(const double *map_3d, const Coordinate *map_2d, int map_size)
{
    Tile *map_tile = malloc(sizeof(Tile) * (map_size - 1) * (map_size - 1) * 2);
    int extrem_index;
    int square[4];

    for (int i = 0, j = 0; i < map_size * map_size - map_size; i++) {
        if (i % map_size == map_size - 1)
            continue;

        square[0] = i;
        square[1] = i + 1;
        square[2] = i + map_size + 1;
        square[3] = i + map_size;

        extrem_index = get_extrem_point_index(map_3d, square);

        map_tile[j++] = create_tile(map_3d, map_2d, map_size,
            square[extrem_index != 0 ? extrem_index - 1 : 3],
            square[extrem_index],
            square[extrem_index != 3 ? extrem_index + 1 : 0]
        );
        map_tile[j++] = create_tile(map_3d, map_2d, map_size,
            square[extrem_index != 3 ? extrem_index + 1 : 0],
            square[extrem_index < 2 ? extrem_index + 2 : extrem_index - 2],
            square[extrem_index != 0 ? extrem_index - 1 : 3]
        );
    }
    return map_tile;
}