import 'package:flutter_test/flutter_test.dart';
import 'package:isometric_world/map.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi';
import 'dart:io';

void main() {
  int mapSize = 3;
  Map map;

  setUpAll(() async {
    var cmake =
        await Process.run('cmake', ['android/app/', '-B', 'build/test']);
    expect(cmake.exitCode, 0);

    var make = await Process.run('make', [], workingDirectory: 'build/test');
    expect(make.exitCode, 0);

    map = Map(mapSize);
  });

  tearDownAll(() {
    malloc.free(map.map3D);
    malloc.free(map.map2D);
    malloc.free(map.mapTilePointer);
  });

  test('Maps should be created', () {
    expect(map.map3D, isNot(nullptr));
    expect(map.map2D, isNot(nullptr));
    expect(map.mapTile.length, (mapSize - 1) * (mapSize - 1) * 2);
  });

  test('Map3D should be created', () {
    for (var i = 0; i < mapSize * mapSize; i++) {
      expect(map.map3D[i], 0);
    }
  });

  test('Map2D should be created', () {
    Pointer<Double> map3D = calloc<Double>(mapSize * mapSize);
    Pointer<Coordinate> map2D = map.create2DMap(map3D, mapSize);
    List<List<double>> coordinates = [
      [0.000000, 0.000000],
      [-23.02652485007213, 11.985638465105076],
      [-46.05304970014426, 23.971276930210152],
      [23.02652485007213, 11.985638465105076],
      [0.000000, 23.971276930210152],
      [-23.02652485007213, 35.95691539531523],
      [46.05304970014426, 23.971276930210152],
      [23.02652485007213, 35.95691539531523],
      [0.000000, 47.942553860420304],
    ];

    for (var i = 0; i < mapSize * mapSize; i++) {
      expect(map2D[i].x, coordinates[i][0]);
      expect(map2D[i].y, coordinates[i][1]);
    }
    calloc.free(map3D);
    malloc.free(map2D);
  });

  test('MapTile should be created', () {
    Pointer<Double> map3D = calloc<Double>(mapSize * mapSize);
    Pointer<Coordinate> map2D = malloc<Coordinate>(mapSize * mapSize);
    Pointer<Tile> mapTile;
    List<List<double>> coordinates = [
      [0.000000, 0.000000],
      [-23.02652485007213, 11.985638465105076],
      [-46.05304970014426, 23.971276930210152],
      [23.02652485007213, 11.985638465105076],
      [0.000000, 23.971276930210152],
      [-23.02652485007213, 35.95691539531523],
      [46.05304970014426, 23.971276930210152],
      [23.02652485007213, 35.95691539531523],
      [0.000000, 47.942553860420304],
    ];
    List<List<List<double>>> tilesCoordinates = [
      [
        [23.02652485007213, 11.985638465105076],
        [0.000000, 0.000000],
        [-23.02652485007213, 11.985638465105076]
      ],
      [
        [-23.02652485007213, 11.985638465105076],
        [0.000000, 23.971276930210152],
        [23.02652485007213, 11.985638465105076]
      ],
      [
        [0.000000, 23.971276930210152],
        [-23.02652485007213, 11.985638465105076],
        [-46.05304970014426, 23.971276930210152]
      ],
      [
        [-46.05304970014426, 23.971276930210152],
        [-23.02652485007213, 35.95691539531523],
        [0.000000, 23.971276930210152]
      ],
      [
        [46.05304970014426, 23.971276930210152],
        [23.02652485007213, 11.985638465105076],
        [0.000000, 23.971276930210152]
      ],
      [
        [0.000000, 23.971276930210152],
        [23.02652485007213, 35.95691539531523],
        [46.05304970014426, 23.971276930210152]
      ],
      [
        [23.02652485007213, 35.95691539531523],
        [0.000000, 23.971276930210152],
        [-23.02652485007213, 35.95691539531523]
      ],
      [
        [-23.02652485007213, 35.95691539531523],
        [0.000000, 47.942553860420304],
        [23.02652485007213, 35.95691539531523]
      ],
    ];
    List<List<int>> colors = [
      [0, 109, 0],
      [0, 110, 0],
      [0, 110, 0],
      [0, 111, 0],
      [0, 111, 0],
      [0, 112, 0],
      [0, 112, 0],
      [0, 113, 0]
    ];

    for (var i = 0; i < mapSize * mapSize; i++) {
      map2D[i].x = coordinates[i][0];
      map2D[i].y = coordinates[i][1];
    }
    mapTile = map.createTileMap(map3D, map2D, mapSize);

    for (var i = 0; i < (mapSize - 1) * (mapSize - 1) * 2; i++) {
      expect(mapTile[i].a.x, tilesCoordinates[i][0][0]);
      expect(mapTile[i].a.y, tilesCoordinates[i][0][1]);
      expect(mapTile[i].b.x, tilesCoordinates[i][1][0]);
      expect(mapTile[i].b.y, tilesCoordinates[i][1][1]);
      expect(mapTile[i].c.x, tilesCoordinates[i][2][0]);
      expect(mapTile[i].c.y, tilesCoordinates[i][2][1]);
      expect(mapTile[i].color.r, colors[i][0]);
      expect(mapTile[i].color.g, colors[i][1]);
      expect(mapTile[i].color.b, colors[i][2]);
    }
    calloc.free(map3D);
    malloc.free(map2D);
    malloc.free(mapTile);
  });
}
