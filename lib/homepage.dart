import 'dart:async';
import 'dart:math';
import 'package:brickbreaker/ball.dart';
import 'package:brickbreaker/bricks.dart';
import 'package:brickbreaker/coverscreen.dart';
import 'package:brickbreaker/gameoverscreen.dart';
import 'package:brickbreaker/player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

// ignore: camel_case_types
enum direction { up, down, left, right }

class _HomePageState extends State<HomePage> {
  double ballX = 0;
  double ballY = 0;
  double ballXincrement = 0.02;
  double ballYincrement = 0.01;
  var ballXDirection = direction.left;
  var ballYDirection = direction.down;

  double playerX = -0.2;
  double playerWidht = 0.4;
  double sensitivity = 1.5;

  static double bricksWidht = 0.3;
  static double bricksHeight = 0.05;
  static double bricksGap = 0.1;
  int numberOfBricksInRow = 4;
  int numberOfRows = 1;
  int hitPoints = 1;
  int round = 1;

  late double wallGap;
  // ignore: non_constant_identifier_names
  late List<List<dynamic>> MyBricks;

  bool hasGameStarted = false;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _generateBricks();
  }

  void _generateBricks() {
    wallGap = 0.5 *
        (2 -
            numberOfBricksInRow * bricksWidht -
            (numberOfBricksInRow - 1) * bricksGap);

    double startY = -0.9;
    MyBricks = [];

    for (int row = 0; row < numberOfRows; row++) {
      for (int col = 0; col < numberOfBricksInRow; col++) {
        double x = -1 + wallGap + col * (bricksWidht + bricksGap);
        double y = startY + row * (bricksHeight + 0.05);
        MyBricks.add([x, y, hitPoints]);
      }
    }
  }

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      updateDirection();
      moveBall();

      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      checkForBrokenBricks();
    });
  }

  bool isPlayerDead() => ballY >= 1;

  void moveBall() {
    setState(() {
      ballY += (ballYDirection == direction.down ? 1 : -1) * ballYincrement;
      ballX += (ballXDirection == direction.right ? 1 : -1) * ballXincrement;
    });
  }

  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidht) {
        ballYDirection = direction.up;

        double randomOffset = (Random().nextDouble() - 0.5) * 0.01;
        ballXincrement += randomOffset;
      } else if (ballY <= -1) {
        ballYDirection = direction.down;
      }

      if (ballX >= 1) ballXDirection = direction.left;
      if (ballX <= -1) ballXDirection = direction.right;
    });
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.2 > -1) playerX -= 0.2;
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + playerWidht < 1) playerX += 0.2;
    });
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      double newPlayerX = playerX +
          (details.primaryDelta! *
              sensitivity /
              MediaQuery.of(context).size.width);
      playerX = newPlayerX.clamp(-1.0, 1 - playerWidht);
    });
  }

  void checkForBrokenBricks() {
    for (int i = 0; i < MyBricks.length; i++) {
      double brickX = MyBricks[i][0];
      double brickY = MyBricks[i][1];
      int lives = MyBricks[i][2];

      if (ballX >= brickX &&
          ballX <= brickX + bricksWidht &&
          ballY <= brickY + bricksHeight &&
          lives > 0) {
        setState(() {
          MyBricks[i][2]--;

          double leftDist = (brickX - ballX).abs();
          double rightDist = (brickX + bricksWidht - ballX).abs();
          double topDist = (brickY - ballY).abs();
          double bottomDist = (brickY + bricksHeight - ballY).abs();

          String min = findMin(leftDist, rightDist, topDist, bottomDist);

          switch (min) {
            case 'left':
              ballXDirection = direction.left;
              break;
            case 'right':
              ballXDirection = direction.right;
              break;
            case 'top':
              ballYDirection = direction.up;
              break;
            case 'bottom':
              ballYDirection = direction.down;
              break;
          }
        });
      }
    }

    bool allBroken = MyBricks.every((b) => b[2] == 0);
    if (allBroken) {
      round++;
      hitPoints++;
      numberOfRows = min(numberOfRows + 1, 5);
      ballXincrement += 0.002;
      ballYincrement += 0.002;
      _generateBricks();
    }
  }

  String findMin(double a, double b, double c, double d) {
    double minVal = [a, b, c, d].reduce(min);
    if ((minVal - a).abs() < 0.01) return 'left';
    if ((minVal - b).abs() < 0.01) return 'right';
    if ((minVal - c).abs() < 0.01) return 'top';
    if ((minVal - d).abs() < 0.01) return 'bottom';
    return '';
  }

  void resetGame() {
    setState(() {
      ballX = 0;
      ballY = 0;
      ballXDirection = direction.left;
      ballYDirection = direction.down;
      playerX = -0.2;
      ballXincrement = 0.02;
      ballYincrement = 0.01;
      numberOfRows = 1;
      round = 1;
      hitPoints = 1;
      hasGameStarted = false;
      isGameOver = false;
      _generateBricks();
    });
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
              CoverScreen(
                  hasGameStarted: hasGameStarted, isGameOver: isGameOver),
              GameOverScreen(isGameOver: isGameOver, onRestart: resetGame),
              MyBall(ballX: ballX, ballY: ballY),
              MyPlayer(
                playerX: playerX,
                playerWidht: playerWidht,
                hasGameStarted: hasGameStarted,
              ),
              for (var brick in MyBricks)
                MyBrick(
                  bricksX: brick[0],
                  bricksY: brick[1],
                  bricksBroken: brick[2] == 0,
                  bricksHeight: bricksHeight,
                  bricksWidht: bricksWidht,
                  hitPointsLeft: brick[2],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
