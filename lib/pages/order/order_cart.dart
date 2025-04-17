import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/submit_order.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/card_order.dart';
import 'package:tadchubite/widget/color.dart';

class ReviewOrderPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
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
                    final product =
                        cartController.cartItems.keys.elementAt(index);

                    final quantity =
                        cartController.cartItems.values.elementAt(index);
                    return CardOrder(
                      imageUrl: product.image.isNotEmpty
                                ? product.image
                                : 'assets/default_image.png',
                      title: product.name,
                      category: product.category,
                      price: 'Rp ${product.price.toStringAsFixed(0)}',
                      onAdd: () {
                        cartController.addToCart(product);
                        orderController.addProductToOrder(product);
                      },
                      onRemove: () {
                        cartController.decreaseQuantity(product);
                      },
                    );
                    // ListTile(
                    //   title: Text(product.name),
                    //   subtitle: Text("Qty: $quantity"),
                    //   trailing: Text("Rp ${(product.price * quantity).toStringAsFixed(0)}"),
                    // );
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => SubmitOrderPage());
              },
              style: ElevatedButton.styleFrom(backgroundColor: yellow),
              child: Text("Lanjutkan ke Konfirmasi",
                  style: TextStyle(color: black)),
            ),
          ],
        ),
      ),
    );
  }
}
