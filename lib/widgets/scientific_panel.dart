import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import '../utils/math_parser.dart';
import 'calc_button.dart';

class ScientificPanel extends StatelessWidget {
  final CalculatorController controller;

  const ScientificPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;
    final angleUnitStr = controller.angleUnit == AngleUnit.degrees ? 'DEG' : 'RAD';

    return AnimatedSize(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
      child: controller.isScientific
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  // Row 1
                  Row(
                    children: [
                      Expanded(
                        child: CalcButton(
                          label: angleUnitStr,
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 13,
                          onTap: controller.toggleAngleUnit,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: 'sin',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 14,
                          onTap: () => controller.inputFunction('sin'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: 'cos',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 14,
                          onTap: () => controller.inputFunction('cos'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: 'tan',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 14,
                          onTap: () => controller.inputFunction('tan'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: 'π',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 16,
                          onTap: () => controller.insertSymbol('π'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Row 2
                  Row(
                    children: [
                      Expanded(
                        child: CalcButton(
                          label: 'e',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 15,
                          onTap: () => controller.insertSymbol('e'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: 'ln',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 14,
                          onTap: () => controller.inputFunction('ln'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: 'log',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 14,
                          onTap: () => controller.inputFunction('log'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: 'xʸ',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 15,
                          onTap: () => controller.inputOperator('^'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: '√',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 16,
                          onTap: () => controller.inputFunction('sqrt'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Row 3
                  Row(
                    children: [
                      Expanded(
                        child: CalcButton(
                          label: '(',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 15,
                          onTap: () => controller.insertSymbol('('),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: ')',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 15,
                          onTap: () => controller.insertSymbol(')'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: 'x²',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 14,
                          onTap: () => controller.applyUnary('sqr'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: '1/x',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 13,
                          onTap: () => controller.applyUnary('inv'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CalcButton(
                          label: '|x|',
                          type: ButtonType.scientific,
                          isDarkMode: isDark,
                          height: 44,
                          fontSize: 14,
                          onTap: () => controller.applyUnary('abs'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
