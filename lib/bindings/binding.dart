import 'package:get/get.dart';
import 'package:tadchubite/dashboard/controller.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/pages/manage%20menu/product_controller.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/order_controller.dart';

class MyBindigs extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(DashboardController());
    Get.put(ProductController());
    Get.put(CartController());
    Get.put(OrderController());
  }
}
