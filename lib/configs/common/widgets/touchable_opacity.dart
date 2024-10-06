import 'package:flutter/material.dart';

class TouchableOpacity extends StatelessWidget {
  const TouchableOpacity({
    super.key,
    required this.color,
    required this.onPressed,
    this.borderRadius = 16,
    required this.child,
    this.borderColor = Colors.transparent,
  });
  final Color color;
  final VoidCallback onPressed;
  final double borderRadius;
  final Widget child;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
