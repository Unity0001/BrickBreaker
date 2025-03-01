import 'dart:math';
import 'package:flutter/material.dart';

class MyBrick extends StatefulWidget {
  final double bricksY;
  final double bricksX;
  final double bricksHeight;
  final double bricksWidht;
  final bool bricksBroken;

  MyBrick({
    required this.bricksHeight,
    required this.bricksWidht,
    required this.bricksX,
    required this.bricksY,
    required this.bricksBroken,
  });

  @override
  _MyBrickState createState() => _MyBrickState();
}

class _MyBrickState extends State<MyBrick> {
  late Color brickColor;

  @override
  void initState() {
    super.initState();
    brickColor = _generateRandomColor();
  }

  Color _generateRandomColor() {
    return Color.fromRGBO(
      Random().nextInt(156) + 50,
      Random().nextInt(156) + 50,
      Random().nextInt(156) + 50,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.bricksBroken
        ? Container()
        : Container(
            alignment: Alignment(
                (2 * widget.bricksX + widget.bricksWidht) /
                    (2 - widget.bricksWidht),
                widget.bricksY),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: MediaQuery.of(context).size.height *
                    widget.bricksHeight /
                    2,
                width:
                    MediaQuery.of(context).size.width * widget.bricksWidht / 2,
                color: brickColor,
              ),
            ),
          );
  }
}
