import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final TextStyle? style;
  final IconData? icon;
  final Color? textColor;
  final Color? borderColor;
  final bool isOutlined;
  final String? imagePath;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? alignment;

  const MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.style,
    this.icon,
    this.textColor,
    this.borderColor,
    this.isOutlined = false,
    this.imagePath,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.alignment, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined 
              ? Colors.transparent 
              : (color ?? theme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            side: isOutlined 
                ? BorderSide(color: borderColor ?? theme.primaryColor) 
                : BorderSide.none,
          ),
          elevation: isOutlined ? 0 : (elevation ?? 2),
          padding: padding,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: alignment ?? MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? (isOutlined ? theme.primaryColor : Colors.white)),
              const SizedBox(width: 8),
            ],
            if (imagePath != null) ...[
              Image.asset(
                imagePath!,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: style ??
                  TextStyle(
                    color: textColor ?? (isOutlined ? theme.primaryColor : Colors.white),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}