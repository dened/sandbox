import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runZonedGuarded<void>(
  () => runApp(const App()),
  (error, stackTrace) => print('Top level exception: $error\n$stackTrace'), // ignore: avoid_print
);

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Material App',
    home: Scaffold(
      appBar: AppBar(title: const Text('Material App Bar')),
      body: const SafeArea(child: Center(child: GameWidget())),
    ),
  );
}

/// {@template box_of_balls}
/// GameWidget widget.
/// {@endtemplate}
class GameWidget extends StatefulWidget {
  /// {@macro box_of_balls}
  const GameWidget({
    super.key, // ignore: unused_element
  });

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

/// State for widget GameWidget.
class _GameWidgetState extends State<GameWidget> {
  late Ticker _ticker;
  late GameState _gameState;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _resetGame();
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _gameState.update();
    });
  }

  void _resetGame() {
    _gameState = GameState(width: 400, height: 400);
  }

  @override
  void didUpdateWidget(covariant GameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
    _ticker.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      CustomPaint(size: Size.infinite, painter: GamePainter(gameState: _gameState)),
      ElevatedButton(
        onPressed: () => _gameState.addBall(Ball(color: Colors.red, radius: 10)),
        child: const Text('Add ball'),
      ),
    ],
  );
}

class GameState {
  /// Creates a new game with the given [width] and [height].
  GameState({required double width, required double height}) : box = Box(width: width, height: height);

  /// The balls in the game.
  final List<Ball> balls = [];

  final Box box;

  /// Adds a ball to the game.
  void addBall(Ball ball) {
    balls.add(ball);
  }

  bool isFinisched = false;

  void update() {
    // Update game state logic here
    // For example, check if the game is finished
    if (isFinisched) return;

    for (final ball in balls) {
      ball.update();
      // Update each ball's position, velocity, etc.
      // This is just a placeholder for actual game logic
      print('Updating ball: $ball');
      if (box.collides(ball)) {
        ball.bounce();
      }
      for (final otherBall in balls) {
        if (ball != otherBall && ball.collidesWith(otherBall)) {
          ball.bounceOff(otherBall);
        }
      }
    }
  }
}

class Box {
  /// Creates a new box with the given [width] and [height].
  Box({required double width, required double height}) : size = Size(width, height);
  final Size size;

  bool collides(Ball ball) {
    // Check for collision with horizontal walls
    if (ball.position.dx - ball.radius < 0 || ball.position.dx + ball.radius > size.width) {
      return true;
    }
    // Check for collision with vertical walls
    if (ball.position.dy - ball.radius < 0 || ball.position.dy + ball.radius > size.height) {
      return true;
    }
    return false;
  }
}

class Ball {
  /// Creates a new ball with the given [color] and [radius].
  Ball({required this.color, required this.radius});

  /// The color of the ball.
  final Color color;

  /// The radius of the ball.
  final double radius;

  Offset position = const Offset(200, 200);
  Offset velocity = const Offset(3, -5);

  double speed = 2;

  @override
  String toString() => 'Ball(color: $color, radius: $radius)';

  void bounce() {
    // Reverse the velocity component that caused the collision
    if (position.dx - radius < 0 || position.dx + radius > 400) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy - radius < 0 || position.dy + radius > 400) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }

  bool collidesWith(Ball other) {
    final distance = (position - other.position).distance;
    return distance < (radius + other.radius);
  }

  void bounceOff(Ball other) {
    // Simple elastic collision for demonstration
    final normal = (position - other.position).normalize();
    final relativeVelocity = velocity - other.velocity;
    final impulse = 2 * (relativeVelocity.dx * normal.dx + relativeVelocity.dy * normal.dy) / 2; // Assuming equal mass
    velocity -= normal * impulse;
    other.velocity += normal * impulse;
  }

  void update() {
    position += velocity;
  }
}

extension OffsetNormalize on Offset {
  /// Returns a normalized (unit length) vector in the same direction as this offset.
  Offset normalize() {
    final length = distance;
    if (length == 0) return this;
    return this / length;
  }
}

class GamePainter extends CustomPainter {
  /// Creates a new game painter with the given [gameState].
  GamePainter({required this.gameState});

  /// The game state to be painted.
  final GameState gameState;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & gameState.box.size, Paint()..color = Colors.grey);

    // Paint the game state
    for (final ball in gameState.balls) {
      final paint = Paint()..color = ball.color;
      canvas.drawCircle(ball.position, ball.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
