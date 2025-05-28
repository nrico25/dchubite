import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tadchubite/api_endpoint.dart';

class ForgotPasswordService {
  static Future<bool> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoint.baseUrl}/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  static Future<bool> resetPassword(
      String email, String otp, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoint.baseUrl}/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}