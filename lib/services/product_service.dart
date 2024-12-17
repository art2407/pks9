import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class ProductService {
  static const String baseUrl = 'http://192.168.56.1:8080';

  // Получить все продукты с сервера
  Future<List<Product>> getProducts() async {
    try {
      print('Fetching products from: $baseUrl/products');
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final List<dynamic> productsJson = json.decode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки продуктов: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка при получении продуктов: $e');
      throw Exception('Не удалось загрузить продукты: $e');
    }
  }

  // Получить продукт по ID
  Future<Product?> getProduct(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Product.fromJson(json);
      }
    } catch (e) {
      print('Error fetching product: $e');
    }
    return null;
  }

  // Создать новый продукт
  Future<Product?> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Product.fromJson(json);
      }
    } catch (e) {
      print('Error creating product: $e');
    }
    return null;
  }

  // Обновить продукт
  Future<Product?> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/update/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Product.fromJson(json);
      }
    } catch (e) {
      print('Error updating product: $e');
    }
    return null;
  }

  // Удалить продукт
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/delete/$id'),
      );
      return response.statusCode == 204;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }
}
