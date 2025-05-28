import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/utils/format_helper.dart';
import 'package:tadchubite/widget/card_order.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/shimer_placeholder.dart';
import 'package:tadchubite/widget/text.dart';
import 'package:tadchubite/widget/textfield.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});
  final TextEditingController searchController = TextEditingController();

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
          text: "List Menu",
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextField(
                        width: 363,
                        controller: searchController,
                        hintText: 'Cari menu disini',
                        keyboardType: TextInputType.text,
                        borderColor: Colors.grey.shade300,
                        borderWidth: 1.0,
                        fillColor: Colors.white,
                        textColor: Colors.black,
                        hintColor: Colors.grey,
                        suffixIcon: Icons.search,
                             onChanged: (value) {
                      orderController.searchProducts(value);
                    },
                      ),
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
                        itemCount: orderController.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final order_product = orderController.filteredProducts[index];
                          return CardOrder(
                            imageUrl: order_product.image.isNotEmpty
                                ? order_product.image
                                : 'assets/default_image.png',
                            title: order_product.name,
                            category: order_product.category,
                            price: 'Rp ${formatRupiah(order_product.price)}',
                            onAdd: () {
                              cartController.addToCart(order_product); 
                              orderController
                                  .addProductToOrder(order_product); 
                            },
                            onRemove: () {
                              cartController.decreaseQuantity(order_product);
                              orderController.decreaseProductQuantity(order_product);
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
                orderController.resetSearch();
                searchController.clear();
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
                      MyText(
                        text: "${cartController.totalItems.value} Item",
                        fontFamily: 'MontserratSemiBold',
                        fontSize: 16,
                        color: white,
                      ),
                    ],
                  ),
                  MyText(
                    text:
                        "Rp. ${formatRupiah(cartController.totalPrice.value)}",
                    fontFamily: 'MontserratSemiBold',
                    fontSize: 16,
                    color: white,
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
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
