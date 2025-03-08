import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/card_menu.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';
import 'package:tadchubite/widget/textfield.dart';

class ProductPage extends StatelessWidget {
  ProductPage({super.key});
  final TextEditingController searchController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: MyText(
          text: "Add New Menu",
          fontFamily: "MontserratBold",
          fontSize: 20,
          color: white,
        ),
        centerTitle: true,
        backgroundColor: yellow,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomTextField(
                      width: 240,
                      controller: searchController,
                      hintText: 'Search here',
                      keyboardType: TextInputType.text,
                      borderColor: Colors.grey.shade300,
                      borderWidth: 1.0,
                      fillColor: Colors.white,
                      textColor: Colors.black,
                      hintColor: Colors.grey,
                      suffixIcon: Icons.search,
                    ),
                    SizedBox(width: 20),
                    MyButton(
                      text: 'Tambah Menu',
                      onPressed: () {},
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
                CardMenu(
                  image: 'assets/dchubitelogo.png',
                  products: 'Om Yopie',
                  categories: 'Makanan',
                  prices: 'Rp 25.000',
                  icon: Icons.edit,
                ),
                CardMenu(
                  image: 'assets/dchubitelogo.png',
                  products: 'Andhika',
                  categories: 'Minuman',
                  prices: 'Rp 30.000',
                  icon: Icons.edit,
                ),
                CardMenu(
                  image: 'assets/dchubitelogo.png',
                  products: 'Rico',
                  categories: 'Sepuh',
                  prices: 'Rp 20.000',
                  icon: Icons.edit,
                ),
                CardMenu(
                  image: 'assets/dchubitelogo.png',
                  products: 'Miqdam',
                  categories: 'jago',
                  prices: 'Rp 20.000',
                  icon: Icons.edit,
                ),
                CardMenu(
                  image: 'assets/dchubitelogo.png',
                  products: 'Om Yopie',
                  categories: 'Makanan',
                  prices: 'Rp 25.000',
                  icon: Icons.edit,
                ),
                CardMenu(
                  image: 'assets/dchubitelogo.png',
                  products: 'Andhika',
                  categories: 'Minuman',
                  prices: 'Rp 30.000',
                  icon: Icons.edit,
                ),
                CardMenu(
                  image: 'assets/dchubitelogo.png',
                  products: 'Rico',
                  categories: 'Sepuh',
                  prices: 'Rp 20.000',
                  icon: Icons.edit,
                ),
                CardMenu(
                  image: 'assets/dchubitelogo.png',
                  products: 'Miqdam',
                  categories: 'jago',
                  prices: 'Rp 20.000',
                  icon: Icons.edit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
