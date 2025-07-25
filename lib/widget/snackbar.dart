import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  final String title;
  final String message;
  final Color backgroundColor;
  final Color titleColor;
  final Color messageColor;
  final SnackPosition position;
  final Duration duration;
  final IconData? icon;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final VoidCallback? onPressed;     // <-- Tambahkan ini
  final String? buttonText;          // <-- Tambahkan ini juga

  CustomSnackbar({
    required this.title,
    required this.message,
    this.backgroundColor = Colors.black,
    this.titleColor = Colors.white,
    this.messageColor = Colors.white,
    this.position = SnackPosition.TOP,
    this.duration = const Duration(seconds: 2),
    this.icon,
    this.titleStyle,
    this.messageStyle,
    this.onPressed,       // <-- Opsional tombol
    this.buttonText,      // <-- Opsional teks tombol
  });

  void show() {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: titleStyle ??
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
      ),
      messageText: Text(
        message,
        style: messageStyle ??
            TextStyle(
              fontSize: 14,
              color: messageColor,
            ),
      ),
      backgroundColor: backgroundColor,
      snackPosition: position,
      duration: duration,
      icon: icon != null ? Icon(icon, color: messageColor) : null,
      borderRadius: 10,
      margin: const EdgeInsets.all(12),
      mainButton: onPressed != null
          ? TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText ?? "OK",
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}
