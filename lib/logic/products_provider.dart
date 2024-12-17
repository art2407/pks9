import 'package:flutter/foundation.dart';
import '../model/product.dart';
import '../services/product_service.dart';

class ProductsProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];

  List<Product> get products => [..._products];

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await _productService.getProducts();
      _products = fetchedProducts;
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
      _products = []; // Очищаем список в случае ошибки
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    try {
      final result = await _productService.updateProduct(updatedProduct);
      if (result != null) {
        final index = _products.indexWhere((p) => p.id == updatedProduct.id);
        if (index >= 0) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final success = await _productService.deleteProduct(id);
      if (success) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}
