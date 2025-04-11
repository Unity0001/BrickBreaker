import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final double bricksX;
  final double bricksY;
  final double bricksWidht;
  final double bricksHeight;
  final bool bricksBroken;
  final int hitPointsLeft;

  const MyBrick({
    super.key,
    required this.bricksX,
    required this.bricksY,
    required this.bricksWidht,
    required this.bricksHeight,
    required this.bricksBroken,
    required this.hitPointsLeft,
  });

  Color getColor() {
    switch (hitPointsLeft) {
      case 3:
        return Colors.red.shade900;
      case 2:
        return Colors.orange.shade600;
      case 1:
        return Colors.yellow.shade600;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (bricksX + 1) * MediaQuery.of(context).size.width / 2,
      top: (bricksY + 1) * MediaQuery.of(context).size.height / 2,
      child: Container(
        width: bricksWidht * MediaQuery.of(context).size.width / 2,
        height: bricksHeight * MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: bricksBroken ? Colors.transparent : getColor(),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
