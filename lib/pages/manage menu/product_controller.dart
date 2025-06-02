import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/widget/color.dart';
import '../manage%20menu/product_model.dart';
import '../manage%20menu/product_service.dart';

class ProductController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final Rxn<int> selectedCategory = Rxn<int>();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isProductsLoaded = false.obs;
  var products = <Product>[].obs;
  var isLoading = false.obs;

  var inactiveProducts = <Product>[].obs;
  var isInactiveLoading = false.obs;
  final RxBool isImageLoading = false.obs;
  final AuthController authController = Get.find<AuthController>();
  var filteredProducts = <Product>[].obs;

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
    fetchInactiveProducts();
    
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
      filteredProducts.assignAll(fetchedProducts);
      isProductsLoaded.value = true;
      checkImageLoading();
    } catch (e) {
      isProductsLoaded.value = false;
      print('Gagal mengambil produk: ');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(Product product, File? imageFile) async {
    isLoading.value = true;
    try {
      Get.back();
      Product newProduct = await ProductService.createProduct(
          authController.token.value, product, imageFile);
      products.add(newProduct);

      searchProducts(searchController.text);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan produk: ',
          colorText: white, backgroundColor: yellow);
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
        products.refresh();

        searchProducts(searchController.text);
      }
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui produk: ');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    isLoading.value = true;
    try {
      await ProductService.deleteProduct(authController.token.value, id);
      products.removeWhere((p) => p.id == id);
      searchProducts(searchController.text);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus produk: ',
          colorText: white, backgroundColor: yellow);
    } finally {
      isLoading.value = false;
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }

  Future<void> fetchInactiveProducts() async {
    isInactiveLoading.value = true;
    try {
      var fetchedInactive =
          await ProductService.fetchInactiveProducts(authController.token.value);
      inactiveProducts.assignAll(fetchedInactive);
    } catch (e) {
      print('Error');
    } finally {
      isInactiveLoading.value = false;
    }
  }

  Future<void> activateProduct(int id) async {
    try {
      await ProductService.activateProduct(authController.token.value, id);
      var activatedProduct =
          inactiveProducts.firstWhere((product) => product.id == id);
      inactiveProducts.removeWhere((product) => product.id == id);
      products.add(activatedProduct);

    
      inactiveProducts.refresh();
      products.refresh();

      Get.snackbar('Success', 'Produk berhasil diaktifkan',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengaktifkan produk: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
}
}
}
