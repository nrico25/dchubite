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

  final AuthController authController = Get.put(AuthController());
  final Rxn<String> selectedCategory = Rxn<String>();
  final List<Map<String, dynamic>> categories = [
    {"name": "Makanan"},
    {"name": "Minuman"},
    {"name": "Snack"},
  ];

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...categories.map((category) {
                return Obx(() => ListTile(
                      title: Text(
                        category["name"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Radio<String>(
                        value: category["name"],
                        groupValue: selectedCategory.value,
                        onChanged: (value) {
                          selectedCategory.value = value;
                        },
                      ),
                      onTap: () {
                        selectedCategory.value = category["name"];
                      },
                    ));
              }).toList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  text: 'Pilih kategori',
                  onPressed: () {},
                  color: yellow,
                  height: 56,
                  elevation: 0,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: "Nama Menu",
                fontFamily: "MontserratBold",
                fontSize: 16,
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 19),
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
                      const SizedBox(height: 8),
                      CustomTextField(
                        width: 180,
                        controller: costController,
                        hintText: 'harga modal',
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
                      const SizedBox(height: 8),
                      CustomTextField(
                        width: 180,
                        controller: priceController,
                        hintText: 'harga jual',
                        keyboardType: TextInputType.number,
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
              const SizedBox(height: 20),
              MyText(
                text: "Kategori",
                fontFamily: "MontserratBold",
                fontSize: 16,
              ),
              const SizedBox(height: 8),
              Obx(() {
                return GestureDetector(
                  onTap: () => _showCategoryPicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCategory.value ?? "Pilih Kategori",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
