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

enum direction{ UP, DOWN}

class _HomePageState extends State<HomePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  var ballDirection = direction.DOWN;

  //player variable
  double playerX = -0.2;
  double playerWidht = 0.4;

  //game  settings
  bool hasGameStarted = false;
  bool isGameOver = false;

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {

      updateDirection();

      moveBall();
      
      //verify player is dead
      if(isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }
      });
    }

    bool isPlayerDead() {
      if(ballY >= 1) {
        return true;
      }
      
      return false;
    }

  void moveBall() {
    setState (() {
      if (ballDirection == direction.DOWN) {
        ballY += 0.01;
      } else if (ballDirection == direction.UP) {
        ballY -= 0.01;
      }
    });
  }

  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidht) {
        ballDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballDirection = direction.DOWN;
      }
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

   void onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      double newPlayerX = playerX + (details.primaryDelta! / MediaQuery.of(context).size.width);
      if (newPlayerX > 1 - playerWidht) {
        playerX = 1 - playerWidht; 
      } else if (newPlayerX < -1) {
        playerX = -1; 
      } else {
        playerX = newPlayerX;
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
      onHorizontalDragUpdate: onHorizontalDragUpdate,
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
              
            ],
          ),
        ),
      ),
    ),
    );
  }
}
