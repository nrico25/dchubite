import 'package:flutter/material.dart';
import 'package:tadchubite/widget/color.dart';

class CardOrder extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String price;
  final VoidCallback onAdd;

  const CardOrder({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 130,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageUrl.startsWith('assets/')
                ? Image.asset(imageUrl, width: 80, height: 80, fit: BoxFit.cover)
                : Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
             SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontFamily: "MontserratBold")),
                   SizedBox(height: 4),
                  Text(category, style: const TextStyle(color: Colors.grey,fontFamily:"MontserratRegular" )),
                   SizedBox(height: 4), 
                  Text(price, style: const TextStyle(color: black,fontFamily: "MontserratRegular")),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Tambah",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: white,
                      fontFamily: "MontserratSemiBold",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
