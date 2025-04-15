import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/card_order.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/shimer_placeholder.dart';
import 'package:tadchubite/widget/text.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});

  final OrderController orderController = Get.put(OrderController());
  final CartController cartController = Get.put(CartController());

  Future<void> _refreshData() async {
    await orderController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: white,
        title: MyText(
          text: "Edit Menu",
          fontFamily: "MontserratBold",
          fontSize: 16,
          color: black,
        ),
        centerTitle: true,
        backgroundColor: white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryButton(label: "Makanan"),
                      SizedBox(width: 8),
                      CategoryButton(label: "Minuman"),
                      SizedBox(width: 8),
                      CategoryButton(label: "Snack"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Obx(() {
                    if (orderController.isLoading.value) {
                      return Column(
                        children:
                            List.generate(5, (index) => ShimmerPlaceholder()),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: orderController.products.length,
                        itemBuilder: (context, index) {
                          final order_product = orderController.products[index];
                          return CardOrder(
                            imageUrl: order_product.image.isNotEmpty
                                ? order_product.image
                                : 'assets/default_image.png',
                            title: order_product.name,
                            category: order_product.category,
                            price:
                                'Rp ${order_product.price.toStringAsFixed(0)}',
                            onAdd: () {
                              cartController.addToCart(order_product); //UI
                              orderController
                                  .addProductToOrder(order_product); //API
                            },
                            onRemove: () {
                              cartController.decreaseQuantity(order_product);
                            },
                          );
                        },
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        if (cartController.totalItems.value > 0) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/cart');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_cart, color: white),
                      SizedBox(width: 8),
                      Text(
                        "${cartController.totalItems.value} Item",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Rp ${cartController.totalPrice.value.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink(); // Sembunyikan tombol jika tidak ada item
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
