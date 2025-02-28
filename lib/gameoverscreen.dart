import 'dart:async';
import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final bool isGameOver;

  GameOverScreen({required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Container(
            alignment: Alignment(0, -0.3),
            child: StreamBuilder<bool>(
              stream: Stream.periodic(
                      Duration(milliseconds: 500), (count) => count.isEven)
                  .asBroadcastStream(),
              builder: (context, snapshot) {
                return AnimatedOpacity(
                  opacity: snapshot.data == true ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 250),
                  child: Text(
                    'G A M E  O V E R',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                );
              },
            ),
          )
        : Container();
  }
}
