import 'package:flutter/material.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class CardMenu extends StatelessWidget {
  final String image;
  final String products;
  final String categories;
  final String prices;
  

  const CardMenu({
    super.key,
    required this.image,
    required this.products,
    required this.categories,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color:lightGray),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
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
                  onPressed: () {},
                ),
                IconButton(
                  icon:  Icon(Icons.delete, color: Colors.red),
                  onPressed: () {

                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
