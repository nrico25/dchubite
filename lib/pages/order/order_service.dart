import 'dart:convert';

import 'package:tadchubite/api_endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:tadchubite/pages/order/order_model.dart';

class OrderService {
  static Future<Map<String, dynamic>> createOrder(
      String token, Order order) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoint.baseUrl}/orders/order'),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal membuat order: ${response.body}");
    }
  }

  static Future<List<Order>> getPendingOrders(String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/orders'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];

      // Fix bagian ini:
      print("Incoming data: ${jsonEncode(data)}"); // ✅ bukan json

      try {
        return data
            .map((order) => Order.fromJson(order))
            .where((order) => order.status == 'pending')
            .toList();
      } catch (e) {
        print("Error parsing order: $e");
        throw Exception("Parsing error: $e");
      }
    } else {
      print("Error response: ${response.body}");
      throw Exception('Failed to load orders');
    }
  }

  static Future<List<Order>> fetchOrders(String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/orders'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<bool> markOrderAsSuccess(int id, String token) async {
    final response = await http.put(
      Uri.parse('${ApiEndpoint.baseUrl}/orders/order/$id/success'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");
    return response.statusCode == 200;
  }
}