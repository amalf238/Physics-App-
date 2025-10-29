import 'dart:math';
import 'package:flutter/material.dart';
import 'wave_calculator_page.dart'; // Only needed if you want to navigate back manually

class AnimationsScreen extends StatefulWidget {
  /// The updated velocity (calculated as frequency * wavelength) from WaveCalculatorPage.
  final double? velocity;

  /// The time taken (in seconds) entered in WaveCalculatorPage.
  final double? timeTaken;

  const AnimationsScreen({Key? key, this.velocity, this.timeTaken})
      : super(key: key);

  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen>
    with TickerProviderStateMixin {
  // Controller for the boat’s gentle up-and-down (floating) animation.
  late AnimationController _boatController;
  late Animation<double> _boatAnimation;

  // Controller and animation for the vertical pulse (moving down and back).
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  // Controller for the continuously running phase animation.
  late AnimationController _phaseController;
  late Animation<double> _phaseAnimation;

  // Flag to indicate that the pulse has finished and the depth should be shown.
  bool _showDepth = false;

  // --- Boat layout parameters ---
  final double _boatWidth = 150;
  final double _boatHeight = 100;
  final double _boatTop = 200; // The boat’s “resting” top position.

  @override
  void initState() {
    super.initState();

    // Initialize the boat floating animation.
    _boatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _boatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _boatController, curve: Curves.easeInOut),
    );
    _boatController.repeat(reverse: true);

    // Initialize the phase controller for continuous horizontal movement.
    _phaseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _phaseAnimation = Tween<double>(begin: 0, end: 1).animate(_phaseController);
    _phaseController.repeat();

    // If velocity and timeTaken are provided, start the vertical pulse animation.
    if (widget.velocity != null && widget.timeTaken != null) {
      // Adjust this scaling factor to control how much of the entered time affects the animation.
      final double scalingFactor = 0.1;
      // The forward (downward) duration is calculated using the scaling factor.
      final int forwardDurationMs =
          (widget.timeTaken! * scalingFactor * 500).round();

      _pulseController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: forwardDurationMs),
      );
      _pulseAnimation =
          Tween<double>(begin: 0, end: 1).animate(_pulseController!);

      _pulseController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _pulseController!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            _showDepth = true;
          });
        }
      });
      _pulseController!.forward();
    }
  }

  @override
  void dispose() {
    _boatController.dispose();
    _pulseController?.dispose();
    _phaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate depth using the updated velocity and timeTaken:
    // depth = (velocity * timeTaken) / 2.
    double? calculatedDepth;
    if (widget.velocity != null && widget.timeTaken != null) {
      calculatedDepth = (widget.velocity! * widget.timeTaken!) / 2;
    }

    final Size screenSize = MediaQuery.of(context).size;
    final double boatLeft = (screenSize.width - _boatWidth) / 2;
    final double boatBase = _boatTop + _boatHeight;
    final double travelDistance = screenSize.height - boatBase - 20;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background.
            Positioned.fill(
              child: Container(color: Colors.lightBlueAccent),
            ),
            // Top row: back button and title.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Instead of creating a new WaveCalculatorPage,
                      // simply pop this screen to return to the existing one.
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'The Depth is..',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // The floating boat.
            AnimatedBuilder(
              animation: _boatController,
              builder: (context, child) {
                return Positioned(
                  top: _boatTop + _boatAnimation.value,
                  left: boatLeft,
                  child: SizedBox(
                    width: _boatWidth,
                    height: _boatHeight,
                    child: Image.asset('assets/boat.png'),
                  ),
                );
              },
            ),
            // The pulse animation represented as a wavy line.
            if (_pulseAnimation != null)
              IgnorePointer(
                ignoring: true,
                child: AnimatedBuilder(
                  animation:
                      Listenable.merge([_pulseController!, _phaseController]),
                  builder: (context, child) {
                    final double progress = _pulseAnimation!.value;
                    final double currentVertexY =
                        boatBase + travelDistance * progress;
                    final double phase = _phaseAnimation.value * 2 * pi;
                    return CustomPaint(
                      painter: WavyLinePainter(
                        boatCenter: screenSize.width / 2,
                        boatBase: boatBase,
                        vertexY: currentVertexY,
                        amplitude: 10.0, // Adjust as needed
                        frequency: 2.0, // Adjust as needed
                        phase: phase,
                      ),
                      size: Size(screenSize.width, screenSize.height),
                    );
                  },
                ),
              ),
            // Display the depth after the pulse returns.
            if (_showDepth && calculatedDepth != null)
              Positioned(
                top: boatBase + 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Depth: ${calculatedDepth.toStringAsFixed(2)} m',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A custom painter that draws a wavy (sine) line from the boat's base down to a vertex.
class WavyLinePainter extends CustomPainter {
  final double boatCenter;
  final double boatBase;
  final double vertexY;
  final double amplitude;
  final double frequency;
  final double phase;

  WavyLinePainter({
    required this.boatCenter,
    required this.boatBase,
    required this.vertexY,
    required this.amplitude,
    required this.frequency,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(boatCenter, boatBase);
    final int segments = 30;
    final double totalLength = vertexY - boatBase;
    for (int i = 0; i <= segments; i++) {
      double t = i / segments;
      double y = boatBase + t * totalLength;
      double xOffset = amplitude * sin(2 * pi * frequency * t + phase);
      double x = boatCenter + xOffset;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavyLinePainter oldDelegate) {
    return oldDelegate.vertexY != vertexY ||
        oldDelegate.boatCenter != boatCenter ||
        oldDelegate.boatBase != boatBase ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.frequency != frequency ||
        oldDelegate.phase != phase;
  }
}
