import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/manage%20menu/product_controller.dart';
import 'package:tadchubite/utils/format_helper.dart';
import 'package:tadchubite/widget/card_menu.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/shimer_placeholder.dart';
import 'package:tadchubite/pages/manage%20menu/empty_product.dart';
import 'package:tadchubite/pages/manage%20menu/network_error.dart';
import 'package:tadchubite/widget/text.dart';

class InactiveProductsPage extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  Future<void> _refreshData() async {
    await productController.fetchInactiveProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Obx(() {
                    if (productController.isInactiveLoading.value) {
                      return Column(
                        children: List.generate(5, (_) => ShimmerPlaceholder()),
                      );
                    } else if (productController.inactiveProducts.isEmpty) {
                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: EmptyProductPage(),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: productController.inactiveProducts.length,
                        itemBuilder: (context, index) {
                          final product =
                              productController.inactiveProducts[index];
                          return CardMenu(
                            image: product.image.isNotEmpty
                                ? product.image
                                : 'assets/default_image.png',
                            products: product.name,
                            categories: product.category,
                            prices: 'Rp ${formatRupiah(product.price)}',       
                            editButton: null,
                            deleteButton: IconButton(
                              icon:
                                  const Icon(CupertinoIcons.restart, color: Colors.green),
                              onPressed: () {
                                productController.activateProduct(product.id);
                              },
                            ),
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
    );
  }
}
