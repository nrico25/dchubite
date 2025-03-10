import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';
import 'package:tadchubite/widget/textfield.dart';

class AddMenu extends StatelessWidget {
  AddMenu({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: MyText(
          text: "Add New Menu",
          fontFamily: "MontserratBold",
          fontSize: 16,
          color: black,
        ),
        centerTitle: true,
        backgroundColor: white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: black),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: "Nama Menu",
                fontFamily: "MontserratBold",
                fontSize: 16,
              ),
              SizedBox(height: 8),
              CustomTextField(
                width: 400,
                controller: nameController,
                hintText: 'Masukan nama menu disini',
                keyboardType: TextInputType.text,
                borderColor: Colors.grey.shade300,
                borderWidth: 1.0,
                fillColor: white,
                textColor: black,
                hintColor: grey,
              ),
              SizedBox(height: 19),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "Harga Modal",
                        fontFamily: "MontserratBold",
                        fontSize: 16,
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        width: 180,
                        controller: costController,
                        hintText: 'harga modal',
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        borderColor: Colors.grey.shade300,
                        borderWidth: 1.0,
                        fillColor: white,
                        textColor: black,
                        hintColor: grey,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "Harga Jual",
                        fontFamily: "MontserratBold",
                        fontSize: 16,
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        width: 180,
                        controller: priceController,
                        hintText: 'harga jual',
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        borderColor: Colors.grey.shade300,
                        borderWidth: 1.0,
                        fillColor: white,
                        textColor: black,
                        hintColor: grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyText(
                text: "Kategori",
                fontFamily: "MontserratBold",
                fontSize: 16,
              ),
              SizedBox(height: 8),
              CustomTextField(
                width: 400,
                controller: categoryController,
                hintText: 'Masukan kategori menu',
                obscureText: true,
                borderColor: Colors.grey.shade300,
                borderWidth: 1.0,
                fillColor: white,
                textColor: black,
                hintColor: grey,
                suffixIcon: Icons.arrow_drop_down_outlined,
              ),
              SizedBox(height: 20),
              MyButton(
                text: 'Add menu',
                onPressed: () {},
                color: yellow,
                fontSize: 18,
                height: 50,
                elevation: 0,
                borderRadius: 12,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      )),
    );
  }
}
