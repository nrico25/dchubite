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

class EditMenu extends StatelessWidget {
  final Product product;
  
  EditMenu({super.key, required this.product}) {
    editMenuController.selectedCategory.value = product.categoryId;
  }

  final ProductController editMenuController = Get.find();
  final AuthController authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = product.name;
    costController.text = product.costPrice.toString();
    priceController.text = product.price.toString();

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: MyText(
          text: "Edit Menu",
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(text: "Foto Menu", fontFamily: "MontserratBold", fontSize: 16),
              const SizedBox(height: 8),
              Obx(() {
                return GestureDetector(
                  onTap: () => editMenuController.pickImage(),
                  child: Container(
                    height: 310,
                    width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Colors.grey.shade200,
                    ),
                    child: editMenuController.selectedImage.value != null &&
                            File(editMenuController.selectedImage.value!.path).existsSync()
                        ? Image.file(
                            File(editMenuController.selectedImage.value!.path),
                            fit: BoxFit.cover,
                          )
                        : (product.image.isNotEmpty
                            ? Image.network(
                                product.image,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Icon(Icons.camera_alt, size: 50, color: Colors.black54),
                              )),
                  ),
                );
              }),
              const SizedBox(height: 20),
              MyText(text: "Nama Menu", fontFamily: "MontserratBold", fontSize: 16),
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
                      MyText(text: "Harga Modal", fontFamily: "MontserratBold", fontSize: 16),
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
                      MyText(text: "Harga Jual", fontFamily: "MontserratBold", fontSize: 16),
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
              MyText(text: "Kategori", fontFamily: "MontserratBold", fontSize: 16),
              const SizedBox(height: 8),
              Obx(() {
                if (editMenuController.categories.isEmpty) {
                  return const Text("Kategori tidak tersedia", style: TextStyle(fontSize: 16));
                }

                final selectedCategory = editMenuController.categories.firstWhereOrNull(
                  (cat) => cat["id"] == editMenuController.selectedCategory.value,
                );

                return GestureDetector(
                  onTap: () => _showCategoryPicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCategory?["name"] ?? "Pilih Kategori",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  text: 'Simpan Menu',
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        costController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      Get.snackbar('Error', 'Semua field harus diisi');
                      return;
                    }
                    final updatedProduct = Product(
                      id: product.id,
                      categoryId: editMenuController.selectedCategory.value ?? -1,
                      category: editMenuController.categories.firstWhereOrNull(
                              (cat) => cat["id"] == editMenuController.selectedCategory.value)?["name"] ?? "",
                      name: nameController.text,
                      price: double.tryParse(priceController.text) ?? 0.0,
                      costPrice: double.tryParse(costController.text) ?? 0.0,
                      image: '',
                    );

                    editMenuController.updateProduct(
                        updatedProduct.id, updatedProduct, editMenuController.selectedImage.value);
                  },
                  color: yellow,
                  height: 48,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    // hasil tidak sesuai dengan 1-3 (0)
    int tempSelectedCategory = editMenuController.selectedCategory.value ?? -1;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...editMenuController.categories.map((category) {
                    return ListTile(
                      title: Text(category["name"]),
                      trailing: Radio<int>(
                        value: category["id"],
                        groupValue: tempSelectedCategory,
                        onChanged: (value) => setState(() => tempSelectedCategory = value ?? -1),
                      ),
                    );
                  }).toList(),
                  MyButton(
                    text: 'Pilih kategori',
                    onPressed: () {
                      editMenuController.selectedCategory.value = tempSelectedCategory;
                      Get.back();
                    },
                    color: yellow,
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