import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tadchubite/api_endpoint.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/pages/manage%20menu/product_model.dart';
import 'package:tadchubite/pages/manage%20menu/product_service.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/order_model.dart';
import 'package:tadchubite/pages/order/order_service.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/snackbar.dart';

class OrderController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var allPendingOrders = <Order>[].obs;
  var orderHistories = <Order>[].obs;
  var filteredOrderHistories = <Order>[].obs;
  var selectedProducts = <OrderItem>[].obs;
  var pendingOrders = <Order>[].obs;
  var customerName = "".obs;
  var paymentMethod = "cash".obs;
  var isLoading = false.obs;
  var paymentSucces = false.obs;
  var amountPaid = 0.obs;

  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();

  @override
  void onInit() {
    print("onInit() dipanggil");
    super.onInit();
    fetchProducts();
    fetchPendingOrders();
    print("onInit() selesai");
    fetchOrderHistories("7");
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      String token = authController.token.value;

      print("Fetching products...");
      var fetchedProducts = await ProductService.fetchProducts(token);
      print("Products fetched: ${fetchedProducts.length}");
      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(fetchedProducts);
    } catch (e) {
      print(e);
      if (!Get.isSnackbarOpen) {
        print("Gagal mengambil produk: ");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void addProductToOrder(Product product) {
    var existing = selectedProducts
        .firstWhereOrNull((item) => item.productId == product.id);
    if (existing != null) {
      existing.quantity++;
      selectedProducts.refresh();
    } else {
      selectedProducts.add(OrderItem(
          productId: product.id,
          quantity: 1,
          price: product.price,
          product: product));
    }
  }

  void removeProductFromOrder(OrderItem orderItem) {
    selectedProducts.remove(orderItem);
  }

  Future<bool> submitOrder() async {
    if (customerName.value.isEmpty ||
        selectedProducts.isEmpty ||
        amountPaid.value <= 0) {
      CustomSnackbar(
        title: "Ups!",
        message: "Data order tidak lengkap",
        backgroundColor: red,
        icon: Icons.error,
        titleStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'MontserratBold',
          fontWeight: FontWeight.bold,
          color: white,
        ),
        messageStyle: TextStyle(
          fontFamily: 'MontserratRegular',
          fontSize: 14,
          color: white,
        ),
      ).show();
      paymentSucces.value = false;
      return false;
    }

    try {
      String token = authController.token.value;
      Order newOrder = Order(
        customerName: customerName.value,
        paymentMethod: paymentMethod.value,
        amountPaid: amountPaid.value,
        items: selectedProducts.toList(),
      );

      var response = await OrderService.createOrder(token, newOrder);

      CustomSnackbar(
        title: "Success",
        message: "Order berhasil dibuat: ${response['order']['order_code']} ",
        backgroundColor: green,
        icon: Icons.check,
        titleStyle: TextStyle(
          fontFamily: 'MontserratBold',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        messageStyle: TextStyle(
          fontFamily: 'MontserratRegular',
          fontSize: 14,
          color: Colors.white70,
        ),
      ).show();
      paymentSucces.value = true;
      return true;
    } catch (e) {
      CustomSnackbar(
        title: "Ups!",
        message: "Nominal pembayaran kurang",
        backgroundColor: red,
        icon: Icons.error,
        titleStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'MontserratRegular',
          fontWeight: FontWeight.bold,
          color: white,
        ),
        messageStyle: TextStyle(
          fontFamily: 'MontserratBold',
          fontSize: 14,
          color: white,
        ),
      ).show();
      paymentSucces.value = false;
      return false;
    }
  }

  Future<void> fetchPendingOrders() async {
    try {
      isLoading.value = true;
      String token = authController.token.value;
      final orders = await OrderService.getPendingOrders(token);
      pendingOrders.value = orders;
      allPendingOrders.assignAll(orders);
    } catch (e) {
      print("Gagal mengambil order: ");
    } finally {
      isLoading.value = false;
    }
  }

  void resetOrderData() {
    selectedProducts.clear();
    customerName.value = "";
    paymentMethod.value = "";
    amountPaid.value = 0;
  }

  void decreaseProductQuantity(Product product) {
    var existing = selectedProducts
        .firstWhereOrNull((item) => item.productId == product.id);
    if (existing != null) {
      if (existing.quantity > 1) {
        existing.quantity--;
      } else {
        selectedProducts.remove(existing);
      }
      selectedProducts.refresh();
    }
  }

  Future<void> completeOrder(int id) async {
    try {
      String token = authController.token.value;
      bool success = await OrderService.markOrderAsSuccess(id, token);
      if (success) {
        pendingOrders.removeWhere((order) => order.id == id);
        CustomSnackbar(
          title: "Success",
          message: "Berhasil menyelesaikan order",
          backgroundColor: green,
          icon: Icons.check,
          titleStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'MontserratRegular',
            fontWeight: FontWeight.bold,
            color: white,
          ),
          messageStyle: TextStyle(
            fontFamily: 'MontserratBold',
            fontSize: 14,
            color: white,
          ),
        ).show();
        await fetchPendingOrders();
      } else {
        CustomSnackbar(
          title: "Error",
          message: "Gagal menyelesaikan order",
          backgroundColor: red,
          icon: Icons.error,
          titleStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'MontserratRegular',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          messageStyle: TextStyle(
            fontFamily: 'MontserratBold',
            fontSize: 14,
            color: Colors.white70,
          ),
        ).show();
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ');
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  void resetSearch() {
    filteredProducts.assignAll(products);
  }

  void searchOrders(String query) {
    if (query.isEmpty) {
      allPendingOrders.assignAll(pendingOrders);
    } else {
      allPendingOrders.assignAll(
        pendingOrders.where((order) {
          final customerNameMatch =
              order.customerName.toLowerCase().contains(query.toLowerCase());
          final orderCodeMatch =
              order.orderCode?.toLowerCase().contains(query.toLowerCase()) ??
                  false;
          return customerNameMatch || orderCodeMatch;
        }).toList(),
      );
    }
  }

  Future<void> fetchOrderHistories(String range) async {
    isLoading.value = true;

    try {
      final token = authController.token.value;
      final fetched = await OrderService.fetchOrderHistory(token, range);

      orderHistories.assignAll(fetched);
    } catch (e) {
      // Kosongkan list supaya UI tidak menampilkan data lama
      orderHistories.clear();

      // Snackbar error
      // CustomSnackbar(
      //   title: "Error",
      //   message: "Gagal mengambil riwayat order",
      //   backgroundColor: red,
      //   icon: Icons.error,
      //   titleStyle: const TextStyle(
      //     fontSize: 16,
      //     fontFamily: 'MontserratRegular',
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //   ),
      //   messageStyle: const TextStyle(
      //     fontFamily: 'MontserratBold',
      //     fontSize: 14,
      //     color: Colors.white70,
      //   ),
      // ).show();
      print("Gagal mengambil riwayat order: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchOrderHistories(String query) {
    if (query.isEmpty) {
      filteredOrderHistories.assignAll(orderHistories);
    } else {
      filteredOrderHistories.assignAll(
        orderHistories.where((order) {
          final customerNameMatch =
              order.customerName.toLowerCase().contains(query.toLowerCase());
          final orderCodeMatch =
              order.orderCode?.toLowerCase().contains(query.toLowerCase()) ??
                  false;
          return customerNameMatch || orderCodeMatch;
        }).toList(),
      );
    }
  }

}
