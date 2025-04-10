import 'package:flutter/material.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/shimer.dart';
import 'package:tadchubite/widget/text.dart';

class CardOrder extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String price;
  final VoidCallback onAdd; // ✅ Changed from String to VoidCallback

  const CardOrder({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.onAdd,
  });

  @override
  State<CardOrder> createState() => _CardOrderState();
}

class _CardOrderState extends State<CardOrder> {
  int quantity = 0;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
    widget.onAdd(); // ✅ Call the callback when adding item
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: lightGray),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  const ShimmerWidget.rectangular(width: 80, height: 80),
                  Image.network(
                    widget.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image,
                          size: 80, color: Colors.grey);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: widget.title,
                    fontSize: 16,
                    fontFamily: 'MontserratBold',
                    color: black,
                  ),
                  MyText(
                    text: widget.category,
                    fontSize: 14,
                    fontFamily: 'MontserratSemiBold',
                    color: grey,
                  ),
                  MyText(
                    text: widget.price,
                    fontSize: 14,
                    fontFamily: 'MontserratRegular',
                    color: darkBlue,
                  ),
                ],
              ),
            ),
            quantity == 0
                ? ElevatedButton(
                    onPressed: _incrementQuantity,
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: MyText(
                      text: "Tambah",
                      fontFamily: "MontserratSemiBold",
                      fontSize: 14,
                      color: white,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _decrementQuantity,
                          icon: Icon(Icons.remove, color: black),
                          style: IconButton.styleFrom(
                            backgroundColor: yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MyText(
                            text: quantity.toString(),
                            fontSize: 16,
                            fontFamily: 'MontserratBold',
                            color: black,
                          ),
                        ),
                        IconButton(
                          onPressed: _incrementQuantity,
                          icon: Icon(Icons.add, color: black),
                          style: IconButton.styleFrom(
                            backgroundColor: yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
