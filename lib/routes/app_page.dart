import 'package:get/get.dart';
import 'package:tadchubite/bindings/binding.dart';
import 'package:tadchubite/dashboard/dashboard.dart';
import 'package:tadchubite/pages/login/login.dart';
import 'package:tadchubite/pages/manage%20menu/add_menu.dart';
import 'package:tadchubite/pages/manage%20menu/products.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/login', page: () => Login(), binding: MyBindigs()),
    GetPage(name: '/dashboard', page: () => DashboardPage(), binding: MyBindigs()),
    GetPage(name: '/products', page: () => ProductPage(), binding: MyBindigs()),
    GetPage(name: '/addmenu', page: () => AddMenu(), binding: MyBindigs()),
  ];
}
