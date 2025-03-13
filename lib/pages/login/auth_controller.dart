import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadchubite/pages/login/login_service.dart';

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
      Get.offAllNamed('/products');
    } catch (e) {
      Get.snackbar('Error', e.toString());
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