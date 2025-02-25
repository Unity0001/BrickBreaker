import 'dart:async';
import 'package:brickbreaker/ball.dart';
import 'package:brickbreaker/coverscreen.dart';
import 'package:brickbreaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;

  //player variable
  double playerX = 0;
  double playerWidht = 0.2;

  //game  settings
  bool hasGameStarted = false;

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        ballY += 0.001;
      });
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerX - 0.2 < -1)) {
        playerX -= 0.2;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(playerX + playerWidht >= 1)) {
        playerX += 0.2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.purple[100],
        body: Center(
          child: Stack(
            children: [
              // tap to play
              CoverScreen(hasGameStarted: hasGameStarted),
              
              //ball
              MyBall(
                ballX: ballX,
                ballY: ballY,
              ),

              //player
              MyPlayer(
                playerX: playerX,
                playerWidht: playerWidht,
              ),

              //where is playerX?
              Container(
                alignment: Alignment(playerX, 0.9),
                child: Container(
                  color: Colors.red,
                  width: 4,
                  height: 15,
                ),
              ),
              Container(
                alignment: Alignment(playerX + playerWidht, 0.9),
                child: Container(
                  color: Colors.green,
                  width: 4,
                  height: 15,
                ),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}
