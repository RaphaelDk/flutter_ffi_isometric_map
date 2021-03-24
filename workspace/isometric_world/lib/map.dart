import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

final DynamicLibrary mapLib = Platform.environment.containsKey('FLUTTER_TEST')
    ? DynamicLibrary.open(
        path.join(Directory.current.path, 'build', 'test', 'libmap.so'))
    : Platform.isAndroid
        ? DynamicLibrary.open("libmap.so")
        : DynamicLibrary.process();

class Coordinate extends Struct {
  @Double()
  double x;

  @Double()
  double y;
}

class TileColor extends Struct {
  @Int32()
  int r;

  @Int32()
  int g;

  @Int32()
  int b;
}

class Tile extends Struct {
  Coordinate a;
  Coordinate b;
  Coordinate c;
  TileColor color;
}

class Map {
  int mapSize = 35;
  Pointer<Double> map3D;
  Pointer<Coordinate> map2D;
  Pointer<Tile> mapTilePointer;
  List<Tile> mapTile = [];

  Map(int mapSize) {
    this.mapSize = mapSize;
    map3D = create3DMap(mapSize);
    map2D = create2DMap(map3D, mapSize);
    mapTilePointer = createTileMap(map3D, map2D, mapSize);
    for (var i = 0; i < (mapSize - 1) * (mapSize - 1) * 2; i++) {
      mapTile.add(mapTilePointer[i]);
    }
  }

  final create3DMap = mapLib.lookupFunction<
      Pointer<Double> Function(Int32 mapSize),
      Pointer<Double> Function(int mapSize)>('create_3d_map');

  final create2DMap = mapLib.lookupFunction<
      Pointer<Coordinate> Function(Pointer<Double> map3D, Int32 mapSize),
      Pointer<Coordinate> Function(
          Pointer<Double> map3D, int mapSize)>('create_2d_map');

  final createTileMap = mapLib.lookupFunction<
      Pointer<Tile> Function(
          Pointer<Double> map3D, Pointer<Coordinate> map2D, Int32 mapSize),
      Pointer<Tile> Function(Pointer<Double> map3D, Pointer<Coordinate> map2D,
          int mapSize)>('create_tile_map');
}
