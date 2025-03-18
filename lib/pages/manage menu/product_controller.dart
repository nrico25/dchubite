import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import '../manage%20menu/product_model.dart';
import '../manage%20menu/product_service.dart';

class ProductController extends GetxController {
  final Rxn<int> selectedCategory =
      Rxn<int>(); // Ubah ke integer untuk ID kategori
  final Rx<File?> selectedImage = Rx<File?>(null);
  var products = <Product>[].obs;
  var isLoading = false.obs;
  final RxBool isImageLoading = false.obs;
  final AuthController authController = Get.find<AuthController>();

  final List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "Makanan"},
    {"id": 2, "name": "Minuman"},
    {"id": 3, "name": "Snack"},
  ];

  void selectCategory(int categoryId) {
    selectedCategory.value = categoryId;
  }

  void checkImageLoading() {
    isImageLoading.value = products.any((product) => product.image.isEmpty);
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void resetSelectedImage() {
    selectedImage.value = null;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    ever(selectedCategory, (value) {
      print("Kategori berubah: $value");
    });
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      var fetchedProducts =
          await ProductService.fetchProducts(authController.token.value);
      products.assignAll(fetchedProducts);
       checkImageLoading();
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(Product product, File? imageFile) async {
    isLoading.value = true;
    try {
      Product newProduct = await ProductService.createProduct(
          authController.token.value, product, imageFile);
      products.add(newProduct);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan produk: $e');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(int id, Product product, File? imageFile) async {
    isLoading.value = true;
    try {
      Product updatedProduct = await ProductService.updateProduct(
          authController.token.value, id, product, imageFile);
      int index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = updatedProduct;
      }
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    isLoading.value = true;
    try {
      await ProductService.deleteProduct(authController.token.value, id);
      products.removeWhere((p) => p.id == id);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus produk: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
