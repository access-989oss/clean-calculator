import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import '../utils/app_colors.dart';

class DisplayArea extends StatelessWidget {
  final CalculatorController controller;

  const DisplayArea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final opColor = isDark ? AppColors.darkOpColor : AppColors.lightOpColor;

    // Calculate dynamic font size based on length
    final exprLen = controller.expression.length;
    double fontSize = 52;
    if (exprLen > 14) {
      fontSize = 28;
    } else if (exprLen > 9) {
      fontSize = 38;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Previous Expression Line
          Text(
            controller.previousExpression,
            style: TextStyle(
              fontSize: 16,
              color: textMuted,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Main Expression (Scrollable horizontally if very long)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              controller.expression,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Real-time Preview Result
          SizedBox(
            height: 28,
            child: Text(
              controller.previewResult,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: opColor,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
