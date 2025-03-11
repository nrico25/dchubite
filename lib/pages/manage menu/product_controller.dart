import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  final Rxn<String> selectedCategory = Rxn<String>();
  final Rx<File?> selectedImage = Rx<File?>(null);

  final List<Map<String, dynamic>> categories = [
    {"name": "Makanan"},
    {"name": "Minuman"},
    {"name": "Snack"},
  ];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }
}
