import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/confirm_order.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/color.dart';

class ReviewOrderPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  ReviewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Review Order")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (cartController.cartItems.isEmpty) {
                  return Center(child: Text("Keranjang kosong"));
                }
                return ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartController.cartItems.keys.elementAt(index);
                    final quantity = cartController.cartItems.values.elementAt(index);
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text("Qty: $quantity"),
                      trailing: Text("Rp ${(product.price * quantity).toStringAsFixed(0)}"),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => ConfirmOrderPage());
              },
              style: ElevatedButton.styleFrom(backgroundColor: yellow),
              child: Text("Lanjutkan ke Konfirmasi", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
