import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/pages/manage%20menu/product_controller.dart';
import 'package:tadchubite/pages/manage%20menu/product_model.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';
import 'package:tadchubite/widget/textfield.dart';

class AddMenu extends StatelessWidget {
  AddMenu({super.key}) {}

  final ProductController addMenuController = Get.find();
  final AuthController authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    addMenuController.selectedImage.value = null;
    addMenuController.selectedCategory.value = null;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        surfaceTintColor: white,
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
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:  EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "Foto Menu",
                  fontFamily: "MontserratBold",
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return GestureDetector(
                    onTap: () => addMenuController.pickImage(),
                    child: Container(
                      height: 310,
                      width: 390,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                        color: Colors.grey.shade200,
                      ),
                      child: addMenuController.selectedImage.value != null
                          ? Image.file(
                              File(addMenuController.selectedImage.value!.path),
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child: Icon(Icons.camera_alt,
                                  size: 50, color: Colors.black54),
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
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
                          width: 170,
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
                          width: 170,
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
                  final selectedCategory = addMenuController.categories
                      .firstWhereOrNull((cat) =>
                          cat["id"] == addMenuController.selectedCategory.value);
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
                            selectedCategory != null
                                ? selectedCategory["name"]
                                : "Pilih Kategori",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.black),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    text: 'Simpan Menu',
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          costController.text.isEmpty ||
                          priceController.text.isEmpty ||
                          addMenuController.selectedCategory.value == null ||
                          addMenuController.selectedImage.value == null) {
                        Get.snackbar('Error', 'Semua field harus diisi');
                        return;
                      }
        
                      final product = Product(
                        id: 0, 
                        categoryId: addMenuController.selectedCategory.value!,
                        category: addMenuController.categories.firstWhere((cat) =>
                            cat["id"] ==
                            addMenuController.selectedCategory.value)["name"],
                        name: nameController.text,
                        price: double.tryParse(priceController.text) ?? 0.0,
                        costPrice: double.tryParse(costController.text) ?? 0.0,
                        image: '', 
                      );
        
                      addMenuController.addProduct(
                          product, addMenuController.selectedImage.value);
                      addMenuController.selectedImage.value = null;
                    },
                    color: yellow,
                    height: 48,
                    elevation: 0,
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    int? tempSelectedCategory =
        addMenuController.selectedCategory.value; // Variabel sementara

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...addMenuController.categories.map((category) {
                    return ListTile(
                      title: Text(
                        category["name"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Radio<int>(
                        value: category["id"],
                        groupValue: tempSelectedCategory,
                        onChanged: (value) {
                          setState(() {
                            tempSelectedCategory =
                                value; // Update pilihan sementara
                          });
                        },
                      ),
                    );
                  }).toList(),
                  SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      text: 'Pilih kategori',
                      onPressed: () {
                        if (tempSelectedCategory != null) {
                          addMenuController
                              .selectCategory(tempSelectedCategory!);
                        }
                        Get.back();
                      },
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
      },
    );
  }
}
