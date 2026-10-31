import 'package:flutter/material.dart';
import '../tokens.dart';

enum RSSkeletonShape { rect, line, circle }

class RSSkeletonBlock extends StatefulWidget {
  final double width;
  final double height;
  final RSSkeletonShape shape;
  final double? radius;

  const RSSkeletonBlock({
    super.key,
    required this.width,
    required this.height,
    this.shape = RSSkeletonShape.rect,
    this.radius,
  });

  const RSSkeletonBlock.line({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.radius = 4,
  }) : shape = RSSkeletonShape.line;

  const RSSkeletonBlock.circle({
    super.key,
    required double diameter,
  })  : width = diameter,
        height = diameter,
        shape = RSSkeletonShape.circle,
        radius = null;

  @override
  State<RSSkeletonBlock> createState() => _RSSkeletonBlockState();
}

class _RSSkeletonBlockState extends State<RSSkeletonBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: RSColors.surfaceCeramic.withOpacity(_animation.value),
            shape: widget.shape == RSSkeletonShape.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: widget.shape == RSSkeletonShape.circle
                ? null
                : BorderRadius.circular(widget.radius ?? RSRadius.card),
          ),
        );
      },
    );
  }
}
