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
  final bool showProgress;           // <-- Tambahan baru

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
    this.onPressed,
    this.buttonText,
    this.showProgress = false,       // <-- default false
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
      messageText: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: messageStyle ??
                  TextStyle(
                    fontSize: 14,
                    color: messageColor,
                  ),
            ),
          ),
          if (showProgress) ...[
            const SizedBox(width: 10),
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          ]
        ],
      ),
      backgroundColor: backgroundColor,
      snackPosition: position,
      duration: showProgress ? const Duration(hours: 1) : duration,
      isDismissible: !showProgress,
      icon: icon != null ? Icon(icon, color: messageColor) : null,
      borderRadius: 10,
      margin: const EdgeInsets.all(12),
      mainButton: onPressed != null
          ? TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText ?? "OK",
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}
