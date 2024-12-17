import 'package:flutter/material.dart';
import '../model/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<Product> _favorites = {};

  Set<Product> get favorites => _favorites;

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
}