import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final String? fontFamily;
  final TextAlign? textAlign;

  const MyText({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.textAlign,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily,
        color: color ?? theme.textTheme.bodyMedium?.color,
      ),
      textAlign: textAlign,
    );
  }
}
