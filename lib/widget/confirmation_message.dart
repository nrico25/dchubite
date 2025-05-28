import 'package:flutter/material.dart';
import 'package:tadchubite/widget/color.dart';

Future<bool?> ConfirmationMessage({
  required BuildContext context,
  String title = 'Confirmation',
  required String message,
  String? cancelText,
  String? confirmText,
  required MaterialColor cancelColor,
  required MaterialColor confirmColor,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  text: message.replaceAll('Selesai', ''),
                  style: const TextStyle(fontSize: 18, fontFamily: 'MontserratReguler'),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cancelColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: Text(
                      cancelText?.isNotEmpty == true ? cancelText! : 'Batal',
                      style: TextStyle(
                        color: cancelColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    ),
                    child: Text(
                      confirmText?.isNotEmpty == true ? confirmText! : 'YA',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
