import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/pages/manage%20menu/add_menu.dart';
import 'package:tadchubite/pages/manage%20menu/edit_menu.dart';
import 'package:tadchubite/pages/manage%20menu/product_controller.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/card_menu.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/shimer_placeholder.dart';
import 'package:tadchubite/widget/textfield.dart';

class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final ProductController productController = Get.find();
  final TextEditingController searchController = TextEditingController();
  final AuthController authController = Get.find();

  Future<void> _refreshData() async {
    await productController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextField(
                    width: 200,
                    controller: searchController,
                    hintText: 'Cari menu disini',
                    keyboardType: TextInputType.text,
                    borderColor: Colors.grey.shade300,
                    borderWidth: 1.0,
                    fillColor: Colors.white,
                    textColor: Colors.black,
                    hintColor: Colors.grey,
                    suffixIcon: Icons.search,
                  ),
                  MyButton(
                    text: 'Tambah Menu',
                    onPressed: () {
                      Get.to(() => AddMenu());
                    },
                    color: yellow,
                    fontSize: 16,
                    height: 53,
                    width: 170,
                    elevation: 0,
                    borderRadius: 12,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Obx(() {
                    if (productController.isLoading.value) {
                      return Column(
                        children:
                            List.generate(5, (index) => ShimmerPlaceholder()),
                      );
                    } else if (!productController.isProductsLoaded.value) {
                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Text(
                              'Gagal mengambil data dari API.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return productController.products.isEmpty
                          ? SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Center(
                                  child: Text(
                                    'Belum ada produk',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: productController.products.length,
                              itemBuilder: (context, index) {
                                final product =
                                    productController.products[index];
                                return CardMenu(
                                  image: product.image.isNotEmpty
                                      ? product.image
                                      : 'assets/default_image.png',
                                  products: product.name,
                                  categories: product.category,
                                  prices:
                                      'Rp ${product.price.toStringAsFixed(0)}',
                                  onEdit: () {
                                    Get.to(() => EditMenu(product: product));
                                  },
                                  onDelete: () {
                                    productController.deleteProduct(product.id);
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
    );
  }
}
