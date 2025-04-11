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
  bool isPause = false;
  bool showSettings = false;

  double ballX = 0;
  double ballY = 0;
  double ballXincrement = 0.02;
  double ballYincrement = 0.01;
  var ballXDirection = direction.left;
  var ballYDirection = direction.down;

  double playerX = -0.2;
  double playerWidht = 0.4;
  double sensitivity = 1.0;

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
      if (isPause) return;

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
    if (isPause) return;

    setState(() {
      double delta = details.primaryDelta! / MediaQuery.of(context).size.width;
      double newPlayerX = playerX + delta * sensitivity;

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
              ...MyBricks.map((brick) {
                final brickX = brick[0];
                final brickY = brick[1];
                final hitPoints = brick[2];
                final isBroken = hitPoints <= 0;

                if (isBroken) return SizedBox();

                return MyBrick(
                  bricksX: brickX,
                  bricksY: brickY,
                  bricksWidht: bricksWidht,
                  bricksHeight: bricksHeight,
                  bricksBroken: isBroken,
                  hitPointsLeft: hitPoints,
                );
              }).toList(),
              MyPlayer(
                playerX: playerX,
                playerWidht: playerWidht,
                hasGameStarted: hasGameStarted,
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.settings, size: 30, color: Colors.black87),
                  onPressed: () {
                    setState(() {
                      showSettings = true;
                      isPause = true;
                    });
                  },
                ),
              ),
              if (showSettings)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Configurações",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 30),
                        Text(
                            "Sensibilidade: ${sensitivity.toStringAsFixed(1)}"),
                        Slider(
                          value: sensitivity,
                          min: 0.5,
                          max: 3.0,
                          divisions: 25,
                          label: sensitivity.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              sensitivity = value;
                            });
                          },
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showSettings = false;
                              isPause = false;
                            });
                          },
                          child: Text("Voltar ao jogo"),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
