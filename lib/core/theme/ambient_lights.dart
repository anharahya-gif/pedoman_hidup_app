import 'dart:ui';
import 'package:flutter/material.dart';

class AmbientLights extends StatelessWidget {
  final bool showGoldGlow;

  const AmbientLights({
    super.key,
    this.showGoldGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isDark) return const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: [
          // Top-Left Emerald Glow
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1a0b3b24), // Green glow (10% opacity)
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Bottom-Right Gold Glow
          if (showGoldGlow)
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x0fbb9e3d), // Gold/Yellow glow (6% opacity)
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
