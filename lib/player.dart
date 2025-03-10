import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerX;
  final playerWidht;
  final bool hasGameStarted;

  MyPlayer({this.playerX, this.playerWidht, required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment:
                Alignment((2 * playerX + playerWidht) / (2 - playerWidht), 0.9),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 10,
                width: MediaQuery.of(context).size.width * playerWidht / 2,
                color: Colors.deepPurple,
              ),
            ),
          )
        : Container();
  }
}
