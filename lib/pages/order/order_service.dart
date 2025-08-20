import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  static Future<List<Order>> fetchOrderHistory(
      String token, String range) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/orders/completed-history?range=$range'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat riwayat order');
    }
  }
      static Future<Directory> getAppDirectory() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        throw Exception("Izin penyimpanan ditolak");
      }
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception("Gagal mendapatkan direktori penyimpanan");
      }
      return directory;
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      return await getTemporaryDirectory();
    }
  }

  static Future<File> downloadAllHistory(String token) async {
    final response = await http.get(
      Uri.parse(
          '${ApiEndpoint.baseUrl}/orders/download?'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/pdf',
      },
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final directory = await getAppDirectory();

      final fileName =
          "Laporan-Bulanan-${DateTime.now().toIso8601String()}.pdf";
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(bytes);

      final fileBytes = await file.readAsBytes();
      debugPrint("10 byte pertama file: ${fileBytes.take(10).toList()}");
      debugPrint("File berhasil disimpan di: ${file.path}");
      debugPrint("Ukuran file: ${fileBytes.length} bytes");

      return file;
    } else {
      throw Exception('Gagal mendownload laporan bulanan');
    }
  }
  static Future<File> downloadWeeklyHistory(String token) async {
    final response = await http.get(
      Uri.parse(
          '${ApiEndpoint.baseUrl}/orders/download?range=7'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/pdf',
      },
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final directory = await getAppDirectory();

      final fileName =
          "Laporan-Bulanan-${DateTime.now().toIso8601String()}.pdf";
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(bytes);

      final fileBytes = await file.readAsBytes();
      debugPrint("10 byte pertama file: ${fileBytes.take(10).toList()}");
      debugPrint("File berhasil disimpan di: ${file.path}");
      debugPrint("Ukuran file: ${fileBytes.length} bytes");

      return file;
    } else {
      throw Exception('Gagal mendownload laporan bulanan');
    }
  }
  static Future<File> downloadMonthlyHistory(String token) async {
    final response = await http.get(
      Uri.parse(
          '${ApiEndpoint.baseUrl}/orders/download?range=30'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/pdf',
      },
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final directory = await getAppDirectory();

      final fileName =
          "Laporan-Bulanan-${DateTime.now().toIso8601String()}.pdf";
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(bytes);

      final fileBytes = await file.readAsBytes();
      debugPrint("10 byte pertama file: ${fileBytes.take(10).toList()}");
      debugPrint("File berhasil disimpan di: ${file.path}");
      debugPrint("Ukuran file: ${fileBytes.length} bytes");

      return file;
    } else {
      throw Exception('Gagal mendownload laporan bulanan');
    }
  }
}
