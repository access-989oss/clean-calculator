import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum ButtonType { number, operator, function, danger, equal, scientific }

class CalcButton extends StatefulWidget {
  final String label;
  final Widget? icon;
  final ButtonType type;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isDarkMode;
  final double height;
  final double fontSize;

  const CalcButton({
    super.key,
    this.label = '',
    this.icon,
    required this.type,
    required this.onTap,
    this.onLongPress,
    required this.isDarkMode,
    this.height = 64,
    this.fontSize = 24,
  });

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color textColor = Colors.white;
    Border? border;
    Gradient? gradient;
    List<BoxShadow>? shadows;

    if (widget.type == ButtonType.equal) {
      gradient = const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = Colors.white;
      shadows = [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
    } else {
      if (widget.isDarkMode) {
        border = Border.all(color: AppColors.darkBorder, width: 1);
        switch (widget.type) {
          case ButtonType.number:
            bgColor = AppColors.darkKeyNum;
            textColor = AppColors.darkTextPrimary;
            break;
          case ButtonType.operator:
            bgColor = AppColors.darkKeyOp;
            textColor = AppColors.darkOpColor;
            break;
          case ButtonType.function:
            bgColor = AppColors.darkKeyFunc;
            textColor = AppColors.darkTextSecondary;
            break;
          case ButtonType.danger:
            bgColor = AppColors.darkKeyFunc;
            textColor = AppColors.danger;
            break;
          case ButtonType.scientific:
            bgColor = AppColors.darkKeySci;
            textColor = AppColors.darkTextSecondary;
            break;
          default:
            bgColor = AppColors.darkKeyNum;
            textColor = AppColors.darkTextPrimary;
        }
      } else {
        border = Border.all(color: AppColors.lightBorder, width: 1);
        switch (widget.type) {
          case ButtonType.number:
            bgColor = AppColors.lightKeyNum;
            textColor = AppColors.lightTextPrimary;
            shadows = [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ];
            break;
          case ButtonType.operator:
            bgColor = AppColors.lightKeyOp;
            textColor = AppColors.lightOpColor;
            break;
          case ButtonType.function:
            bgColor = AppColors.lightKeyFunc;
            textColor = AppColors.lightTextSecondary;
            break;
          case ButtonType.danger:
            bgColor = AppColors.lightKeyFunc;
            textColor = AppColors.dangerLight;
            break;
          case ButtonType.scientific:
            bgColor = AppColors.lightKeySci;
            textColor = AppColors.lightTextSecondary;
            break;
          default:
            bgColor = AppColors.lightKeyNum;
            textColor = AppColors.lightTextPrimary;
        }
      }
    }

    final borderRadius = BorderRadius.circular(widget.type == ButtonType.scientific ? 14 : 22);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: gradient == null ? bgColor : null,
          gradient: gradient,
          borderRadius: borderRadius,
          border: border,
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            onTapDown: (_) => _animController.forward(),
            onTapUp: (_) => _animController.reverse(),
            onTapCancel: () => _animController.reverse(),
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Center(
              child: widget.icon ??
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: widget.fontSize,
                      fontWeight: widget.type == ButtonType.equal ||
                              widget.type == ButtonType.danger ||
                              widget.type == ButtonType.operator
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
