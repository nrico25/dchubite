import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color fillColor;
  final Color textColor;
  final Color hintColor;
  final double width;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    required this.borderColor,
    required this.borderWidth,
    this.borderRadius = 16,
    required this.fillColor,
    required this.textColor,
    required this.hintColor,
    required this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 53,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        ),
      ),
    );
  }
}
