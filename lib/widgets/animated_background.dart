import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _rand = Random();
  final List<Offset> _stars = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 50; i++) {
      _stars.add(Offset(_rand.nextDouble(), _rand.nextDouble()));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/aaaa.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment(0.7, -0.1),
            ),
          ),
        ),

        Container(color: Colors.black.withOpacity(0.3)),

        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _StarPainter(_stars, _controller.value),
              child: Container(),
            );
          },
        ),

        widget.child,
      ],
    );
  }
}

class _StarPainter extends CustomPainter {
  final List<Offset> stars;
  final double progress;
  _StarPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.7);
    for (var star in stars) {
      final x = (star.dx + progress) % 1.0 * size.width;
      final y = star.dy * size.height;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
