import 'package:flutter/material.dart';
import 'package:tadchubite/widget/card_order.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Mencegah overflow kategori
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryButton(label: "Makanan"),
                    const SizedBox(width: 8),
                    CategoryButton(label: "Minuman"),
                    const SizedBox(width: 8),
                    CategoryButton(label: "Snack"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12.0),
                children: [
                  CardOrder(
                    imageUrl: 'assets/dchubitelogo.png'
                        .trim(), 
                    title: 'Mie Level 1',
                    category: 'Makanan',
                    price: '10.000',
                    onAdd: () {},
                  ),
                  CardOrder(
                    imageUrl: 'assets/dchubitelogo.png'
                        .trim(), 
                    title: 'Mie Level 1',
                    category: 'Makanan',
                    price: '10.000',
                    onAdd: () {},
                  ),
                  CardOrder(
                    imageUrl: 'assets/dchubitelogo.png'
                        .trim(), 
                    title: 'Mie Level 1',
                    category: 'Makanan',
                    price: '10.000',
                    onAdd: () {},
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

class CategoryButton extends StatelessWidget {
  final String label;

  const CategoryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }
}
