import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/submit_order.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/card_order.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class ReviewOrderPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  ReviewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: white,
        title: MyText(
          text: "Keranjang",
          fontFamily: "MontserratBold",
          fontSize: 18,
          color: black,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
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
                    final order_product = orderController.products[index];
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
                        orderController.decreaseProductQuantity(product);
                      },
                    );

                    // );
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            MyButton(text: "Lanjutkan Konfirmasi", onPressed: () {
              Get.to(() => SubmitOrderPage());
            }, color: yellow, height: 56, elevation: 0, borderRadius: 12),
            
          ],
        ),
      ),
    );
  }
}
