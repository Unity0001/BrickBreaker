import 'dart:async';
import 'package:brickbreaker/ball.dart';
import 'package:brickbreaker/bricks.dart';
import 'package:brickbreaker/coverscreen.dart';
import 'package:brickbreaker/gameoverscreen.dart';
import 'package:brickbreaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  double ballXincrement = 0.01;
  double ballYincrement = 0.01;
  var ballXDirection = direction.LEFT;
  var ballYDirection = direction.DOWN;

  //player variables
  double playerX = -0.2;
  double playerWidht = 0.4;

  //bricks variables
  double bricksX = 0;
  double bricksY = -0.9;
  double bricksWidht = 0.4;
  double bricksHeight = 0.05;
  bool bricksBroken = false;

  //game  settings
  bool hasGameStarted = false;
  bool isGameOver = false;

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      updateDirection();

      moveBall();

      //verify player is dead
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      checkForBrokenBricks();
    });
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }

    return false;
  }

  void moveBall() {
    setState(() {
      //vertically
      if (ballYDirection == direction.DOWN) {
        ballY += ballYincrement;
      } else if (ballYDirection == direction.UP) {
        ballY -= ballYincrement;
      }

      //horizontally
      if (ballXDirection == direction.LEFT) {
        ballX -= ballXincrement;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += ballXincrement;
      }
    });
  }

  void updateDirection() {
    setState(() {

      //ball when hits player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidht) {
        ballYDirection = direction.UP;
      } 
      //ball when hits top of screen
      else if (ballY <= -1) {
        ballYDirection = direction.DOWN;
      }
    //ball goes left when hits right wall
    if (ballX >= 1) {
      ballXDirection = direction.LEFT;
    }
    //ball goes right when hits left wall
    if (ballX <= -1) {
      ballXDirection = direction.RIGHT;
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
      double newPlayerX =
          playerX + (details.primaryDelta! / MediaQuery.of(context).size.width);
      if (newPlayerX > 1 - playerWidht) {
        playerX = 1 - playerWidht;
      } else if (newPlayerX < -1) {
        playerX = -1;
      } else {
        playerX = newPlayerX;
      }
    });
  }

  void checkForBrokenBricks() {
    if (ballX >= bricksX &&
        ballX <= bricksX + bricksWidht &&
        ballY <= bricksY + bricksHeight &&
        bricksBroken == false) {
      setState(() {
        bricksBroken = true;
        ballYDirection = direction.DOWN;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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

              //Game Over
              GameOverScreen(isGameOver: isGameOver),

              //player
              MyPlayer(
                playerX: playerX,
                playerWidht: playerWidht,
              ),

              //bricks
              MyBricks(
                bricksHeight: bricksHeight,
                bricksWidht: bricksWidht,
                bricksX: bricksX,
                bricksY: bricksY,
                bricksBroken: bricksBroken,
              )
            ],
          ),
        ),
      ),
    );
  }
}
