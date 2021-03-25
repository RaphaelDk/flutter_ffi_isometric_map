#include "map.h"

float interpolate(float a0, float a1, float w) {
    return (a1 - a0) * (3.0 - w * 2.0) * w * w + a0;
}

Coordinate randomGradient(int ix, int iy) {
    float random = 2920.f * sin(ix * 21942.f + iy * 171324.f + 8912.f) * cos(ix * 23157.f * iy * 217832.f + 9758.f);
    return (Coordinate) { .x = cos(random), .y = sin(random) };
}

float dotGridGradient(int ix, int iy, float x, float y) {
    Coordinate gradient = randomGradient(ix, iy);

    float dx = x - (float)ix;
    float dy = y - (float)iy;

    return (dx * gradient.x + dy * gradient.y);
}

float perlin(float x, float y) {
    int x0 = (int)x;
    int x1 = x0 + 1;
    int y0 = (int)y;
    int y1 = y0 + 1;

    float sx = x - (float)x0;
    float sy = y - (float)y0;

    float n0, n1, ix0, ix1, value;

    n0 = dotGridGradient(x0, y0, x, y);
    n1 = dotGridGradient(x1, y0, x, y);
    ix0 = interpolate(n0, n1, sx);

    n0 = dotGridGradient(x0, y1, x, y);
    n1 = dotGridGradient(x1, y1, x, y);
    ix1 = interpolate(n0, n1, sx);

    value = interpolate(ix0, ix1, sy);
    return value;
}