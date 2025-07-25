import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadchubite/pages/login/login_service.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/snackbar.dart';

class AuthController extends GetxController {
  var token = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? "";
  }

  Future<void> login(String email, String password) async {
    try {
      String newToken = await LoginService.login(email, password);
      token.value = newToken;
      await _saveToken(newToken);
      Get.offAllNamed('/dashboard');
    } catch (e) {
      CustomSnackbar(
        title: "Login Gagal",
        message: "Username atau password salah.",
        backgroundColor: red,
        icon: Icons.error,
        titleStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'MontserratBold',
          color: Colors.white,
        ),
        messageStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'MontserratRegular',
          color: Colors.white,
        ),
      ).show();
    }
  }

  Future<void> _saveToken(String newToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
  }

  Future<void> logout() async {
    token.value = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAllNamed('/login');
  }
}
