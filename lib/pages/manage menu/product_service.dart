import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tadchubite/api_endpoint.dart';
import 'package:tadchubite/pages/manage%20menu/product_model.dart';

class ProductService {
  static Future<List<Product>> fetchProducts(String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/products'),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == true) {
        print(body['data']);
        return (body['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception(body['message'] ?? "Gagal mengambil data produk");
      }
    } else {
      throw Exception(
          "Gagal mengambil data produk. Status: ${response.statusCode}");
    }
  }

  static Future<Product> createProduct(
      String token, Product product, File? imageFile) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse('${ApiEndpoint.baseUrl}/products'));
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    request.fields["category_id"] = product.categoryId.toString();
    request.fields["name"] = product.name;
    request.fields["price"] = product.price.toString();
    request.fields["cost_price"] = product.costPrice.toString();

    if (imageFile != null && isValidImage(imageFile)) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    print("Response Status: ${response.statusCode}");
    print("Response Body: $responseData");

    var body = jsonDecode(responseData);
    if (response.statusCode == 201 && body['status'] == true) {
      return Product.fromJson(body['data']);
    } else {
      throw Exception(
          "Gagal menambahkan produk: ${body['message'] ?? responseData}");
    }
  }

  static Future<Product> updateProduct(
      String token, int id, Product product, File? imageFile) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse('${ApiEndpoint.baseUrl}/products/$id'));
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    request.fields["_method"] = "PUT";
    request.fields["category_id"] = product.categoryId.toString();
    request.fields["name"] = product.name;
    request.fields["price"] = product.price.toString();
    request.fields["cost_price"] = product.costPrice.toString();

    if (imageFile != null && isValidImage(imageFile)) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    print("Response Status: ${response.statusCode}");
    print("Response Body: $responseData");

    var body = jsonDecode(responseData);
    if (response.statusCode == 200 && body['status'] == true) {
      return Product.fromJson(body['data']);
    } else {
      throw Exception(
          "Gagal memperbarui produk: ${body['message'] ?? responseData}");
    }
  }

  static Future<void> deleteProduct(String token, int id) async {
    final response = await http.delete(
      Uri.parse('${ApiEndpoint.baseUrl}/products/$id'),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] != true) {
        throw Exception(body['message'] ?? "Gagal menghapus produk");
      }
    } else {
      throw Exception("Gagal menghapus produk. Status: ${response.statusCode}");
    }
  }

  static bool isValidImage(File imageFile) {
    String extension = imageFile.path.split('.').last.toLowerCase();
    return ["jpeg", "png", "jpg", "gif"].contains(extension);
  }

  static Future<List<Product>> fetchInactiveProducts(String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint.baseUrl}/products/inactive'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch inactive products');
    }
  }

  static Future<void> activateProduct(String token, int id) async {
    final response = await http.put(
      Uri.parse('${ApiEndpoint.baseUrl}/products/$id/activate'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to activate product');
    }
  }
}
