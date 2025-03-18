import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/manage%20menu/edit_menu.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/shimer.dart';
import 'package:tadchubite/widget/text.dart';

class CardMenu extends StatelessWidget {
  final String image;
  final String products;
  final String categories;
  final String prices;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardMenu({
    super.key,
    required this.image,
    required this.products,
    required this.categories,
    required this.prices,
    required this.onEdit,
    required this.onDelete,
  });

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
                  // Shimmer yang akan tampil saat gambar belum selesai loading
                  const ShimmerWidget.rectangular(width: 80, height: 80),

                  // Gambar produk dengan loadingBuilder
                  Image.network(
                    image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Gambar selesai loading, tampilkan
                      } else {
                        return const SizedBox(); // Sembunyikan sampai gambar selesai loading
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 80, color: Colors.grey);
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
                    text: products,
                    fontSize: 16,
                    fontFamily: 'MontserratBold',
                    color: black,
                  ),
                  MyText(
                    text: categories,
                    fontSize: 14,
                    fontFamily: 'MontserratSemiBold',
                    color: grey,
                  ),
                  MyText(
                    text: prices,
                    fontSize: 14,
                    fontFamily: 'MontserratRegular',
                    color: darkBlue,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: onEdit, 
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
