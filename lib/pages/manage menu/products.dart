import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    return AppBar(
      title: Text("Manage Product"),
      leading: IconButton(onPressed: () {
        authController.logout();
      }, icon: Icon(Icons.logout)),
    );
  }
}