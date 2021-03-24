import 'package:flutter/material.dart';
import 'map.dart';
import 'dart:ui';

main() => runApp(MyApp());

class DrawTriangleShape extends CustomPainter {
  Paint painter = Paint();
  Map map = Map(35);

  DrawTriangleShape() {
    painter.style = PaintingStyle.fill;
  }

  void drawTriangle(Canvas canvas, Tile tile) {
    Path path = Path();

    path.moveTo(tile.a.x, tile.a.y - 400);
    path.lineTo(tile.b.x, tile.b.y - 400);
    path.lineTo(tile.c.x, tile.c.y - 400);
    path.close();

    painter.color =
        Color.fromARGB(255, tile.color.r, tile.color.g, tile.color.b);
    canvas.drawPath(path, painter);
  }

  @override
  void paint(Canvas canvas, Size size) {
    map.mapTile.forEach((tile) => drawTriangle(canvas, tile));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(size: Size(0, 0), painter: DrawTriangleShape()),
    );
  }
}
