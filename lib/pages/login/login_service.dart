import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tadchubite/api_endpoint.dart';

class LoginService {
  static Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoint.baseUrl}/login'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['token'];
      } else {
        final body = jsonDecode(response.body);
        throw body['message'];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
