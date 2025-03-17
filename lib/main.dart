import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/routes/app_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding terinisialisasi
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Tampilkan loading saat token dimuat
        }

        final initialRoute = snapshot.data!.isNotEmpty ? '/dashboard' : '/login';

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'POS DCHubite',
          initialRoute: initialRoute,
          getPages:AppPages.routes,
        );
      },
    );
  }
}