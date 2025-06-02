import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ory/core/common/constants/constants.dart';

/// An animated SVG logo widget for AI processing states
class AnimatedAiLogo extends StatefulWidget {
  /// Creates an animated SVG logo
  ///
  /// The [isAnimating] parameter controls whether the logo is animated or static
  /// The [size] parameter controls the size of the logo
  const AnimatedAiLogo({super.key, required this.isAnimating, this.size = 50});

  /// Whether the logo should be animated
  final bool isAnimating;

  /// The size of the logo
  final double size;

  @override
  State<AnimatedAiLogo> createState() => _AnimatedAiLogoState();
}

class _AnimatedAiLogoState extends State<AnimatedAiLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedAiLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isAnimating ? _pulseAnimation.value : 1.0,
          child: Transform.rotate(
            angle: widget.isAnimating ? _rotateAnimation.value : 0.0,
            child: SvgPicture.asset(Constants.svgLogo, height: widget.size),
          ),
        );
      },
    );
  }
}

/// A centered logo with optional loading text
class CenteredLogoWithText extends StatelessWidget {
  const CenteredLogoWithText({
    super.key,
    required this.isLoading,
    required this.loadingText,
    required this.logoSize,
  });

  final bool isLoading;
  final String loadingText;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedAiLogo(isAnimating: isLoading, size: logoSize),
        const SizedBox(height: 20),
        Text(
          loadingText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
