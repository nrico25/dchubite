import 'package:get/get.dart';
import 'package:tadchubite/pages/login/login.dart';
import 'package:tadchubite/pages/manage%20menu/products.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/login', page: () => Login()),
    GetPage(name: '/products', page: () => ProductPage()),
  ];
}

