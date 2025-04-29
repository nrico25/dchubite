import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/pages/manage%20menu/add_menu.dart';
import 'package:tadchubite/pages/manage%20menu/edit_menu.dart';
import 'package:tadchubite/pages/manage%20menu/empty_product.dart';
import 'package:tadchubite/pages/manage%20menu/network_error.dart';
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

  void DeleteConfirmation(BuildContext context, int productId) {
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      titleStyle: TextStyle(fontFamily: "MontserratSemiBold", color: darkBlue),
      middleText: "Apakah Anda yakin ingin menghapus produk ini?",
      middleTextStyle: TextStyle(fontFamily: "MontserratRegular", color: black),
      radius: 10,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            backgroundColor: green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text("Batal", style: TextStyle(color: white)),
        ),
        ElevatedButton(
          onPressed: () {
            productController.deleteProduct(productId);
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text("Hapus", style: TextStyle(color: white)),
        ),
      ],
    );
  }

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
                    onChanged: (value) {
                      productController.searchProducts(value);
                    },
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
                          child: Center(child: NetworkErrorPage()),
                        ),
                      );
                    } else {
                      return productController.products.isEmpty
                          ? SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: EmptyProductPage()),
                            )
                          : ListView.builder(
                              itemCount:
                                  productController.filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product =
                                    productController.filteredProducts[index];
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
                                    DeleteConfirmation(context, product.id);
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
