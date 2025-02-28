import 'dart:math';

import 'package:flutter/material.dart';

class MyBricks extends StatelessWidget {
  final bricksY;
  final bricksX;
  final bricksHeight;
  final bricksWidht;
  final bricksBroken;

  MyBricks(
      {this.bricksHeight,
      this.bricksWidht,
      this.bricksX,
      this.bricksY,
      required this.bricksBroken});

  Color getRandomColor() {
    Color color;
    do {
      color = Color.fromRGBO(
        Random().nextInt(156) + 50,
        Random().nextInt(156) + 50,
        Random().nextInt(156) + 50,
        1,
      );
    } while (color == Colors.deepPurple);
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return bricksBroken
        ? Container()
        : Container(
            alignment: Alignment(bricksX, bricksY),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: MediaQuery.of(context).size.height * bricksHeight / 2,
                width: MediaQuery.of(context).size.width * bricksWidht / 2,
                color: getRandomColor(),
              ),
            ),
          );
  }
}
