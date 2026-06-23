import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class RubElHizb extends StatelessWidget {
  final int number;
  final double size;
  final Color? color;

  const RubElHizb({
    super.key,
    required this.number,
    this.size = 38,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.accent;
    final double squareSize = size * 0.75;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background rotated square 1
          Transform.rotate(
            angle: 0,
            child: Container(
              width: squareSize,
              height: squareSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: activeColor.withOpacity(0.8), width: 1.5),
              ),
            ),
          ),
          // Background rotated square 2 (45 degrees)
          Transform.rotate(
            angle: 0.785398, // 45 degrees in radians
            child: Container(
              width: squareSize,
              height: squareSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: activeColor.withOpacity(0.8), width: 1.5),
              ),
            ),
          ),
          // Center circle to make the number highly readable
          Container(
            width: size * 0.52,
            height: size * 0.52,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
          // The Number
          Text(
            '$number',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: size * 0.32,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
