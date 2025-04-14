import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/pages/manage%20menu/product_model.dart';
import 'package:tadchubite/pages/manage%20menu/product_service.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/order_model.dart';
import 'package:tadchubite/pages/order/order_service.dart';

class OrderController extends GetxController {
  var products = <Product>[].obs;
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
  }
Future<void> fetchProducts() async {
  try {
    isLoading.value = true; 

    String token = authController.token.value; 

    print("Fetching products...");
    var fetchedProducts = await ProductService.fetchProducts(token);
    print("Products fetched: ${fetchedProducts.length}");

    products.assignAll(fetchedProducts);
  } catch (e) {
    print(e);
    if (!Get.isSnackbarOpen) {
      Get.snackbar("Error", "Gagal mengambil produk: $e");
    }
  } finally {
    isLoading.value = false; // Sembunyikan shimmer setelah selesai
  }
}

  void addProductToOrder(Product product) {
    var existing = selectedProducts
        .firstWhereOrNull((item) => item.productId == product.id);
    if (existing != null) {
      existing.quantity++;
      selectedProducts.refresh();
    } else {
      selectedProducts.add(
          OrderItem(productId: product.id, quantity: 1, price: product.price));
    }
  }

  void removeProductFromOrder(OrderItem orderItem) {
    selectedProducts.remove(orderItem);
  }

Future<bool> submitOrder() async {
  if (customerName.value.isEmpty ||
      selectedProducts.isEmpty ||
      amountPaid.value <= 0) {
    Get.snackbar("Error", "Data order belum lengkap");
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
    Get.snackbar("Success", "Order berhasil dibuat: ${response['order']['order_code']}");
    paymentSucces.value = true;
    return true;
  } catch (e) {
    Get.snackbar("Error", "$e");
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
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil order: $e");
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

  Future<void> completeOrder(int id) async {
    try {
      String token = authController.token.value;
      bool success = await OrderService.markOrderAsSuccess(id, token);
      if (success) {
        pendingOrders.removeWhere((order) => order.id == id);
        Get.snackbar('Success', 'Order marked as completed');
      } else {
        Get.snackbar('Error', 'Gagal menyelesaikan order');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  
}