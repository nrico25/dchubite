import 'package:flutter/material.dart';
import 'package:tadchubite/widget/shimer.dart';

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [

            const ShimmerWidget.rectangular(width: 80, height: 80),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerWidget.rectangular(width: 120, height: 16),
                  const SizedBox(height: 6),
                  const ShimmerWidget.rectangular(width: 80, height: 14),
                  const SizedBox(height: 6),
                  const ShimmerWidget.rectangular(width: 100, height: 14),
                ],
              ),
            ),

            Row(
              children: [
                const ShimmerWidget.circular(width: 32, height: 32),
                const SizedBox(width: 8),
                const ShimmerWidget.circular(width: 32, height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
