import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircular;

  const ShimmerWidget.rectangular({
    Key? key,
    required this.width,
    required this.height,
  })  : isCircular = false,
        super(key: key);

  const ShimmerWidget.circular({
    Key? key,
    required this.width,
    required this.height,
  })  : isCircular = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: isCircular ? null : BorderRadius.circular(8.0),
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}
