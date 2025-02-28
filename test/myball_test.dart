import 'package:brickbreaker/ball.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test MyBall widget rendering', (WidgetTester tester) async {
    // create widget with ballX & ballY defined
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyBall(ballX: 0.5, ballY: 0.5),
        ),
      ),
    );

    // Checks if the widget is rendered
    expect(find.byType(MyBall), findsOneWidget);

    // Checks if the container with the ball is present
    final ballFinder = find.byType(Container);
    expect(
        ballFinder,
        findsNWidgets(
            2)); // You should find 2 containers (the MyBall one and the internal one)

    // Tests if the container alignment is correct based on the ballX and ballY values
    final containerWidget =
        tester.widget<Container>(find.byType(Container).last);
    final alignment = containerWidget.alignment;

    // Checks if the alignment is of type Alignment (which has properties x and y)
    expect(alignment, isA<Alignment>());
    final alignmentValue = alignment as Alignment;

    expect(alignmentValue.x, 0.5);
    expect(alignmentValue.y, 0.5);
  });
}
