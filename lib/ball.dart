import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// The main entry point for the Flutter application.
/// Runs the [GameWidget] as the body of a [Scaffold].
void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: GameWidget())));
}

/// {@template game_widget}
/// A widget that represents the main game area.
/// It is a [StatefulWidget] that manages the game state and animation.
/// {@endtemplate}
class GameWidget extends StatefulWidget {
  /// {@macro game_widget}
  @override
  State<GameWidget> createState() => _GameWidgetState();
}

/// The state for [GameWidget].
/// Manages the game loop using a [Ticker] and updates the UI.
class _GameWidgetState extends State<GameWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late GameState _gameState;
  double _fps = 0;
  DateTime _lastFrameTime = DateTime.now();
  int _frameCount = 0;

  @override
  /// Initializes the game state and starts a [Ticker] for frame updates.
  void initState() {
    super.initState();
    _resetGame();
    _lastFrameTime = DateTime.now(); // Initialize for FPS calculation
    _ticker = createTicker((elapsed) {
      _frameCount++;
      final currentTime = DateTime.now();
      final elapsedTime = currentTime.difference(_lastFrameTime);

      setState(() {
        if (elapsedTime.inMilliseconds >= 500) {
          // Update FPS every 0.5 seconds
          _fps = _frameCount / (elapsedTime.inMilliseconds / 1000.0);
          _frameCount = 0;
          _lastFrameTime = currentTime;
        }
        _gameState.update();
      });
    })..start();
  }

  /// Resets the game state to its initial state.
  void _resetGame() {
    _gameState = GameState();
  }

  @override
  /// Disposes the [Ticker] resources when the widget is removed.
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    /// Uses a [Stack] to overlay the game area ([CustomPaint]) and the game over screen.
    children: [
      CustomPaint(
        painter: GamePainter(
          _gameState,
          fps: _fps,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        ),
        size: Size.infinite,
      ),
      if (_gameState.isFinished)
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('ESCAPED!', style: TextStyle(fontSize: 32, color: Colors.white)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => setState(_resetGame), child: const Text('Restart')),
            ],
          ),
        ),
    ],
  );
}

/// {@template game_state}
/// A class that manages all game logic: the state of the ball, rings, and overall progress.
/// {@endtemplate}
class GameState {
  /// {@macro game_state}
  /// Initializes the rings when the game state is created.
  GameState() {
    for (var i = 0; i < ringCount; i++) {
      rings.add(Ring(i));
    }
  }

  /// The ball object, controlled by the player.
  final ball = Ball();

  /// A list to store ball positions for drawing a trail.
  final List<Offset> ballTrail = [];

  /// A list of active particles for the explosion animation.
  final List<Particle> particles = [];

  /// A list of all rings in the game.
  final List<Ring> rings = [];

  /// The total number of rings to pass through.
  final int ringCount = 20;

  /// The number of particles to create for each ring explosion.
  final particleCount = 5000;

  /// A flag indicating whether the game is finished.
  bool isFinished = false;

  /// Updates the game state for one frame.
  void update() {
    if (isFinished) return;

    // Update and remove "dead" particles.
    particles.removeWhere((particle) {
      particle.update();
      return particle.isDead;
    }); // Keep the last 30 points for the trail
    if (ballTrail.length > 30) {
      ballTrail.removeRange(0, ballTrail.length - 30);
    }

    const subSteps = 6; // The more, the more accurate the physics
    for (var i = 0; i < subSteps; i++) {
      ball.updateStep();

      final ringsToKeep = <Ring>[];
      for (final ring in rings) {
        ring.rotate();
        if (ring.collides(ball)) {
          ball.bounce();
          ringsToKeep.add(ring); // Keep the ring
        } else if (ring.passedThroughGap(ball)) {
          // The ring has been passed, trigger an explosion and do not add it to the list to be kept.
          _explodeRing(ring);
        } else {
          // The ring was not touched, keep it.
          ringsToKeep.add(ring);
        }
      }
      // Update the main list of rings.
      rings
        ..clear()
        ..addAll(ringsToKeep);

      if (rings.isEmpty && particles.isEmpty) {
        isFinished = true;
        break;
      }
    }

    ballTrail.add(ball.position); // Add the current ball position to the trail
    ball.updateVelocityDecay();
  }

  /// Creates a particle explosion effect for the specified ring.
  void _explodeRing(Ring ring) {
    final arcAngle = 2 * pi - 2 * ring.gapAngle;
    final angleIncrement = arcAngle / particleCount;
    for (var i = 0; i < particleCount; i++) {
      final angle = ring.angle + ring.gapAngle + i * angleIncrement;
      final position = Offset.fromDirection(angle, ring.radius);
      final speed = 1.0 + Random().nextDouble() * 2.5;
      // Direct particles radially outward from the center, with a wider random spread.
      // 'angle' is already the radial direction from the center to the point on the ring.
      final velocity = Offset.fromDirection(
        angle + (Random().nextDouble() - 0.5) * (pi / 2),
        speed,
      ); // Spread of 90 degrees (pi/2)
      particles.add(Particle(position: position, velocity: velocity, color: Colors.orangeAccent));
    }
  }
}

/// {@template ball}
/// A class representing the ball in the game.
/// Manages its position, velocity, gravity, and interaction with the rings.
/// {@endtemplate}
class Ball {
  /// {@macro ball}
  Offset position = Offset.zero;
  Offset velocity = const Offset(-4, 0);
  final Offset _baseGravity = const Offset(0, 0.4);
  double radius = 8;
  double defaultSpeed = 6;
  double speedMultiplier = 1;
  double _gravityMultiplier = 1;
  int _gravityBoostFrames = 0;

  /// The current gravity, which can change (e.g., after a bounce).
  Offset get gravity => _baseGravity * _gravityMultiplier;

  /// Updates the ball's position and velocity for one substep.
  /// Used for more accurate physics.
  void updateStep() {
    // Apply gravity, scaled for the substep.
    velocity += gravity * (1 / 6);

    // Limit the ball's speed.
    final angle = velocity.direction;
    final magnitude = velocity.distance;
    final cappedSpeed = defaultSpeed * speedMultiplier;
    velocity = Offset(cos(angle), sin(angle)) * min(magnitude, cappedSpeed);

    // Update the ball's position, scaled for the substep.
    position += velocity * (1 / 6);
  }

  /// Reduces the speed multiplier over time, returning it to [defaultSpeed].
  void updateVelocityDecay() {
    if (speedMultiplier > 1.0) {
      speedMultiplier -= 0.01;
      if (speedMultiplier < 1.0) speedMultiplier = 1.0;
    }

    // Reduce the duration of the weakened gravity.
    if (_gravityBoostFrames > 0) {
      _gravityBoostFrames--;
      if (_gravityBoostFrames == 0) {
        _gravityMultiplier = 1.0; // Return gravity to its normal value
      }
    }
  }

  /// Handles the ball's bounce off a ring.
  ///
  /// Rolls back the ball's position to prevent it from getting stuck.
  /// Changes the direction of the ball's velocity, adding a random deflection.
  /// Increases the ball's speed after a bounce.
  void bounce() {
    // Roll back the position to prevent getting stuck inside the ring.
    // This is a simple heuristic that can be improved for more accurate collision physics.
    position -= velocity * 0.5;

    // Calculate the new bounce direction.
    // Add pi to the current angle for reflection and a random deflection.
    final currentAngle = velocity.direction;
    final deflection = (Random().nextDouble() - 0.5) * pi / 3;
    final bounceAngle = currentAngle + pi + deflection;

    // Set the new velocity and increase the speed multiplier.
    velocity = Offset(cos(bounceAngle), sin(bounceAngle)) * defaultSpeed * 1.5;
    speedMultiplier = 1.8;

    // Temporarily weaken gravity so the ball can fly higher.
    _gravityMultiplier = 0.2; // For example, 40% of normal gravity
    _gravityBoostFrames = 120; // Lasts for 120 frames (approximately 2 seconds at 60 FPS)
  }
}

/// {@template particle}
/// Класс, представляющий одну частицу для анимации взрыва.
/// {@endtemplate}
class Particle {
  /// {@macro particle}
  Particle({required this.position, required this.velocity, this.color = Colors.blueAccent, double lifespan = 360})
    : initialLifespan = lifespan,
      _lifespan = lifespan;
  final Offset _baseGravity = const Offset(0, 0.2);
  Offset position;
  Offset velocity;
  Color color;
  final double initialLifespan;
  double _lifespan;

  double get lifespan => _lifespan;
  bool get isDead => _lifespan <= 0;

  void update() {
    position += velocity + _baseGravity;
    _lifespan--;
  }
}

/// {@template ring}
/// A class representing a single ring in the game.
/// Manages its size, rotation, and collision/passthrough checks.
/// {@endtemplate}
class Ring {
  /// {@macro ring}
  /// [level] determines the radius of the ring.
  /// [speed] is initialized with a random value for varied rotation.
  // Reduce rotation speed to simplify the game.
  Ring(this.level) : speed = 0.0005 + level * 0.00005;

  /// The level of the ring, used to determine its radius.
  final int level;

  /// The current rotation angle of the ring.
  double angle = 0;

  /// The rotation speed of the ring.
  double speed;

  /// The distance between adjacent rings.
  final double spacing = 15;

  /// The angle that defines the size of the gap in the ring.
  final double gapAngle = pi / 8;

  /// Calculates the radius of the ring based on its level and [spacing].
  double get radius => 100 + level * spacing;

  /// Rotates the ring based on its speed.
  void rotate() {
    angle += speed;
  }

  /// Checks if the ball has passed through the ring's gap.
  ///
  /// Returns `true` if the ball is within the ring's thickness
  /// and its angle corresponds to the gap's angle.
  bool passedThroughGap(Ball ball) {
    final ballAngle = atan2(ball.position.dy, ball.position.dx);
    final ballRadius = ball.position.distance;

    if ((ballRadius - radius).abs() < 10) {
      final localAngle = (ballAngle - angle) % (2 * pi);
      if (localAngle < gapAngle || localAngle > 2 * pi - gapAngle) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the ball has collided with the ring.
  ///
  /// Returns `true` if the ball is within the ring's thickness
  /// and has not passed through the gap.
  bool collides(Ball ball) {
    final r = ball.position.distance;
    if ((r - radius).abs() < 10 && !passedThroughGap(ball)) {
      return true;
    }
    return false;
  }
}

/// {@template game_painter}
/// A class responsible for drawing the game state on a [Canvas].
/// {@endtemplate}
class GamePainter extends CustomPainter {
  /// {@macro game_painter}
  GamePainter(this.state, {required this.fps, required this.textDirection, required this.textScaler})
    : _points = Float32List(state.particleCount * 2);

  /// The current game state to be drawn.
  final GameState state;
  final double fps;
  final TextDirection textDirection;
  final TextScaler textScaler;

  /// A list of points to draw particles using [drawRawPoints].
  /// This is more efficient than drawing each particle individually,
  /// especially when there are many particles.
  final Float32List _points;

  /// Paint used for drawing particles.
  final Paint _particlePaint =
      Paint()
        ..strokeWidth = 1
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.square
        ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw a black background for the game area
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    // Draw FPS and element counts in the top-left corner
    const textStyle = TextStyle(color: Colors.white, fontSize: 14);
    double currentTextY = 10; // Starting Y position for text

    void drawText(String text, Canvas canvas, double yOffset) {
      TextPainter(text: TextSpan(text: text, style: textStyle), textDirection: textDirection, textScaler: textScaler)
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(canvas, Offset(10, yOffset)); // 10px padding from left
    }

    drawText('FPS: ${fps.toStringAsFixed(1)}', canvas, currentTextY);
    currentTextY += 20; // Move down for next line
    drawText('Rings: ${state.rings.length}', canvas, currentTextY);
    currentTextY += 20;
    drawText('Trail: ${state.ballTrail.length}', canvas, currentTextY);
    currentTextY += 20;
    drawText('Particles: ${state.particles.length}', canvas, currentTextY);

    final center = size.center(Offset.zero);
    canvas.translate(center.dx, center.dy);

    final ringPaint =
        Paint()
          ..color = Colors.blueAccent
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    for (final ring in state.rings) {
      final r = ring.radius;
      final gapStart = ring.angle;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: r),
        gapStart + ring.gapAngle,
        2 * pi - 2 * ring.gapAngle,
        false,
        ringPaint,
      );
    }

    // Draw the ball's trail
    for (var i = 0; i < state.ballTrail.length; i++) {
      final trailPoint = state.ballTrail[i];
      final progress = i / state.ballTrail.length;
      final trailRadius = state.ball.radius * progress * 0.9; // The trail shrinks and fades
      final trailOpacity = progress * 0.8; // The trail fades
      final trailPaint = Paint()..color = Colors.orange.withValues(alpha: trailOpacity);
      canvas.drawCircle(trailPoint, trailRadius, trailPaint);
    }

    // Draw the ball with a stretching effect
    final ballPaint = Paint()..color = Colors.orange;
    canvas
      ..save() // Save the current state of the canvas
      ..translate(state.ball.position.dx, state.ball.position.dy); // Move the origin to the center of the ball

    // Calculate the stretch factor based on speed
    final speedMagnitude = state.ball.velocity.distance;
    // Normalize the speed relative to the maximum speed to get a factor from 0 to 1
    // Assume the maximum ball speed can be around defaultSpeed * 1.8 (after a bounce)
    final maxPossibleSpeed = state.ball.defaultSpeed * 1.8;
    final stretchFactor = (speedMagnitude / maxPossibleSpeed).clamp(0.0, 1.0) * 0.2; // Maximum stretch of 20%

    // Rotate the canvas in the direction of the ball's movement
    canvas
      ..rotate(state.ball.velocity.direction)
      ..drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: state.ball.radius * 2 * (1 + stretchFactor),
          height: state.ball.radius * 2 * (1 - stretchFactor),
        ),
        ballPaint,
      )
      ..restore(); // Restore the canvas state

    if (state.particles.isNotEmpty) {
      canvas
        ..save()
        ..clipRect(Rect.fromLTWH(-size.width / 2, -size.height / 2, size.width, size.height));

      _drawParticles(canvas, state.particles);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// Draws the particles on the canvas.
  /// Uses [drawRawPoints] for better performance with a large number of particles.
  /// The particles are drawn as points with a color that fades based on their lifespan.
  void _drawParticles(Canvas canvas, List<Particle> particles) {
    for (var batch = 0; batch < particles.length; batch += state.particleCount) {
      final particle = particles[batch]; // Use the last particle to determine color
      final alpha = (particle.lifespan / particle.initialLifespan).clamp(0.0, 1.0); // Alpha from 0.0 to 1.0

      final particlePaint = _particlePaint..color = particle.color.withValues(alpha: alpha);
      for (var i = 0; i < state.particleCount; i++) {
        final particle = particles[i + batch];
        _points[i * 2] = particle.position.dx;
        _points[i * 2 + 1] = particle.position.dy;
      }
      // Draw particles using drawRawPoints
      canvas.drawRawPoints(PointMode.points, _points, particlePaint);
    }
  }
}
