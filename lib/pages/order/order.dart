import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/card_order.dart';
import 'package:tadchubite/widget/shimer_placeholder.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});

  final OrderController orderController = Get.put(OrderController());

  Future<void> _refreshData() async {
    await orderController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
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
                            final order_product =
                                orderController.products[index];
                            return CardOrder(
                                imageUrl: order_product.image.isNotEmpty
                                    ? order_product.image
                                    : 'assets/default_image.png',
                                title: order_product.name,
                                category: order_product.category,
                                price:
                                    'Rp ${order_product.price.toStringAsFixed(0)}',
                                onAdd: () {});
                          },
                        );
                      }
                    }),
                  ),
                ),
              ],
            )),
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
