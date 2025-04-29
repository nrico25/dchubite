import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tadchubite/api_endpoint.dart';
import 'package:tadchubite/pages/finance/finance_model.dart';

class ReportService {
  static Future<List<FinanceGraph>> fetchMonthlyReport(String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/reports/monthly'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => FinanceGraph.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data monthly report');
    }
  }

  static Future<List<FinanceGraph>> fetchWeeklyReport(String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/reports/monthly'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => FinanceGraph.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data weekly report');
    }
  }

  static Future<List<FinanceGraph>> fetchAllReport(String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/reports/all'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => FinanceGraph.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data all report');
    }
  }

  static Future<CategoryReport> fetchCategoryReport(
      String token, int categoryId) async {
    final response = await http.get(
      Uri.parse(
          '${ApiEndpoint.baseUrl}/reports/category?category_id=$categoryId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return CategoryReport.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil laporan kategori');
    }
  }

  Future<List<CategorySalesModel>> fetchSoldByCategory(
      String date, String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/reports/sold-by-category'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['sold_by_category'];
      return list.map((item) => CategorySalesModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
