import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/manage%20menu/inactive_product.dart';
import 'package:tadchubite/pages/manage%20menu/product_controller.dart';
import 'package:tadchubite/pages/manage%20menu/products.dart';
import 'package:tadchubite/widget/color.dart';

class TabProductPage extends StatelessWidget {
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          automaticallyImplyLeading: false,
          title: TabBar(
            indicatorColor: yellow,
            labelColor: yellow,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                  child: Text(
                'Active',
                style: TextStyle(
                  fontFamily: 'MontserratRegular', // Sama di sini
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              )),
              Tab(
                  child: Text(
                'Inactive',
                style: TextStyle(
                  fontFamily: 'MontserratRegular', // Sama di sini
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [ProductPage(), InactiveProductsPage()],
        ),
      ),
    );
  }
}