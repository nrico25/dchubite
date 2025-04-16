import 'package:get/get.dart';
import 'package:tadchubite/bindings/binding.dart';
import 'package:tadchubite/dashboard/dashboard.dart';
import 'package:tadchubite/pages/login/login.dart';
import 'package:tadchubite/pages/manage%20menu/add_menu.dart';
import 'package:tadchubite/pages/manage%20menu/products.dart';
import 'package:tadchubite/pages/order/nota.dart';
import 'package:tadchubite/pages/order/order.dart';
import 'package:tadchubite/pages/order/order_cart.dart';
import 'package:tadchubite/pages/setting/printer_choice.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/login', page: () => Login(), binding: MyBindigs()),
    GetPage(name: '/dashboard', page: () => DashboardPage(), binding: MyBindigs()),
    GetPage(name: '/products', page: () => ProductPage(), binding: MyBindigs()),
    GetPage(name: '/addmenu', page: () => AddMenu(), binding: MyBindigs()),
    GetPage(name: '/cart', page: () => ReviewOrderPage(), binding: MyBindigs()),
    GetPage(name: '/order', page: () => OrderPage(), binding: MyBindigs()),
    GetPage(name: '/setting', page: () => PrinterChoice(), binding: MyBindigs()),
    GetPage(name: '/nota', page: () => NotaPage(order: Get.arguments),)
    
  ];
}
