import 'dart:async';
import 'package:flutter/material.dart';

class GameOverScreen extends StatefulWidget {
  final bool isGameOver;
  final Function onRestart;

  GameOverScreen({required this.isGameOver, required this.onRestart});

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.isGameOver
        ? Stack(
            children: [
              Container(
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
              ),
              Container(
                alignment: Alignment(0, 0),
                child: GestureDetector(
                  onTap: () {
                    widget.onRestart();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: Text(
                        'Play Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : Container();
  }
}
