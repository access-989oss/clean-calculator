import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/calc_button.dart';
import '../widgets/display_area.dart';
import '../widgets/history_bottom_sheet.dart';
import '../widgets/scientific_panel.dart';

class CalculatorScreen extends StatelessWidget {
  final CalculatorController controller;

  const CalculatorScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isDark = controller.isDarkMode;
        final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
        final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // --- TOP BAR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo & Mode Pill
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'CALC',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: controller.toggleScientific,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      controller.isScientific ? 'SCI' : 'BASIC',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Icon(
                                      controller.isScientific
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Action Buttons: History & Theme
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.history_rounded, color: textSecondary, size: 22),
                              tooltip: 'History',
                              onPressed: () => HistoryBottomSheet.show(context, controller),
                            ),
                            IconButton(
                              icon: Icon(
                                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                color: textSecondary,
                                size: 22,
                              ),
                              tooltip: 'Toggle Theme',
                              onPressed: controller.toggleTheme,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- DISPLAY AREA ---
                  Expanded(
                    child: DisplayArea(controller: controller),
                  ),

                  // --- SCIENTIFIC PANEL (Expandable) ---
                  ScientificPanel(controller: controller),

                  // --- STANDARD KEYPAD (4x5 Grid) ---
                  _buildStandardKeypad(isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStandardKeypad(bool isDark) {
    const double spacing = 10;
    const double btnHeight = 66;

    return Column(
      children: [
        // Row 1: AC, Backspace, %, ÷
        Row(
          children: [
            Expanded(
              child: CalcButton(
                label: 'AC',
                type: ButtonType.danger,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 22,
                onTap: controller.clear,
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                icon: Icon(
                  Icons.backspace_outlined,
                  size: 22,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                type: ButtonType.function,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: controller.backspace,
                onLongPress: controller.clear,
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '%',
                type: ButtonType.function,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 22,
                onTap: controller.inputPercent,
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '÷',
                type: ButtonType.operator,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 28,
                onTap: () => controller.inputOperator('÷'),
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing),

        // Row 2: 7, 8, 9, ×
        Row(
          children: [
            Expanded(
              child: CalcButton(
                label: '7',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('7'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '8',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('8'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '9',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('9'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '×',
                type: ButtonType.operator,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 28,
                onTap: () => controller.inputOperator('×'),
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing),

        // Row 3: 4, 5, 6, -
        Row(
          children: [
            Expanded(
              child: CalcButton(
                label: '4',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('4'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '5',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('5'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '6',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('6'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '−',
                type: ButtonType.operator,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 28,
                onTap: () => controller.inputOperator('−'),
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing),

        // Row 4: 1, 2, 3, +
        Row(
          children: [
            Expanded(
              child: CalcButton(
                label: '1',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('1'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '2',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('2'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '3',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('3'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '+',
                type: ButtonType.operator,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 28,
                onTap: () => controller.inputOperator('+'),
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing),

        // Row 5: ±, 0, ., =
        Row(
          children: [
            Expanded(
              child: CalcButton(
                label: '±',
                type: ButtonType.function,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 22,
                onTap: controller.toggleSign,
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '0',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                onTap: () => controller.inputDigit('0'),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '.',
                type: ButtonType.number,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 24,
                onTap: controller.inputDot,
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: CalcButton(
                label: '=',
                type: ButtonType.equal,
                isDarkMode: isDark,
                height: btnHeight,
                fontSize: 30,
                onTap: controller.calculate,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
