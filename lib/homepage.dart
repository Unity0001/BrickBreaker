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
  double ballX = 0;
  double ballY = 0;
  double ballXincrement = 0.02;
  double ballYincrement = 0.01;
  var ballXDirection = direction.LEFT;
  var ballYDirection = direction.DOWN;

  double playerX = -0.2;
  double playerWidht = 0.4;

  static double firstBricksX = -1 + wallGap;
  static double firstBricksY = -0.9;
  static double bricksWidht = 0.4;
  static double bricksHeight = 0.05;
  static double bricksGap = 0.2;
  static int numberOfBricksInRow = 3;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * bricksWidht -
          (numberOfBricksInRow - 1) * bricksGap);

  List MyBricks = [
    [firstBricksX + 0 * (bricksWidht + bricksGap), firstBricksY, false],
    [firstBricksX + 1 * (bricksWidht + bricksGap), firstBricksY, false],
    [firstBricksX + 2 * (bricksWidht + bricksGap), firstBricksY, false],
  ];

  bool hasGameStarted = false;
  bool isGameOver = false;

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

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }

    return false;
  }

  void moveBall() {
    setState(() {
      if (ballYDirection == direction.DOWN) {
        ballY += ballYincrement;
      } else if (ballYDirection == direction.UP) {
        ballY -= ballYincrement;
      }

      if (ballXDirection == direction.LEFT) {
        ballX -= ballXincrement;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += ballXincrement;
      }
    });
  }

  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidht) {
        ballYDirection = direction.UP;
      } else if (ballY <= -1) {
        ballYDirection = direction.DOWN;
      }

      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      }

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
    for (int i = 0; i < MyBricks.length; i++) {
      if (ballX >= MyBricks[i][0] &&
          ballX <= MyBricks[i][0] + bricksWidht &&
          ballY <= MyBricks[i][1] + bricksHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;

          double leftSideDist = (MyBricks[i][0] - ballX).abs();
          double rightSideDist = (MyBricks[i][0] + ballX).abs();
          double topSideDist = (MyBricks[i][1] - ballX).abs();
          double bottomSideDist = (MyBricks[i][1] + ballX).abs();

          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch (min) {
            case 'left':
              ballXDirection = direction.LEFT;

              break;
            case 'right':
              ballXDirection = direction.RIGHT;

              break;
            case 'up':
              ballYDirection = direction.UP;

              break;
            case 'down':
              ballYDirection = direction.DOWN;

              break;
            default:
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [
      a,
      b,
      c,
      d,
    ];

    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'bottom';
    }
    return '';
  }

  void resetGame() {
    setState(() {
      ballX = 0;
      ballY = 0;
      ballXDirection = direction.LEFT;
      ballYDirection = direction.DOWN;
      playerX = -0.2;
      MyBricks = [
        [firstBricksX + 0 * (bricksWidht + bricksGap), firstBricksY, false],
        [firstBricksX + 1 * (bricksWidht + bricksGap), firstBricksY, false],
        [firstBricksX + 2 * (bricksWidht + bricksGap), firstBricksY, false],
      ];
      isGameOver = false;
      hasGameStarted = false;
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
                hasGameStarted: hasGameStarted,
                isGameOver: isGameOver,
              ),
              MyBall(
                ballX: ballX,
                ballY: ballY,
              ),
              GameOverScreen(
                isGameOver: isGameOver,
                onRestart: resetGame,
              ),
              MyPlayer(
                playerX: playerX,
                playerWidht: playerWidht,
                hasGameStarted: hasGameStarted,
              ),
              MyBrick(
                bricksX: MyBricks[0][0],
                bricksY: MyBricks[0][1],
                bricksBroken: MyBricks[0][2],
                bricksHeight: bricksHeight,
                bricksWidht: bricksWidht,
              ),
              MyBrick(
                bricksX: MyBricks[1][0],
                bricksY: MyBricks[1][1],
                bricksBroken: MyBricks[1][2],
                bricksHeight: bricksHeight,
                bricksWidht: bricksWidht,
              ),
              MyBrick(
                bricksX: MyBricks[2][0],
                bricksY: MyBricks[2][1],
                bricksBroken: MyBricks[2][2],
                bricksHeight: bricksHeight,
                bricksWidht: bricksWidht,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
