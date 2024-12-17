import 'dart:convert';

class Product {
  final String id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Создание Product из JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ID'].toString(),
      title: json['Name'],
      description: json['Description'],
      price: (json['Price'] as num).toInt(),
      imageUrl: json['ImageURL'],
    );
  }

  // Преобразование Product в JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': int.parse(id),
      'Name': title,
      'Description': description,
      'Price': price,
      'ImageURL': imageUrl,
    };
  }
}

// Функция для загрузки демо-продуктов из JSON строки
List<Product> loadProductsFromJson(String jsonString) {
  final Map<String, dynamic> data = json.decode(jsonString);
  final List<dynamic> productsJson = data['products'];
  return productsJson.map((json) => Product.fromJson(json)).toList();
}

// Демо-продукты теперь будут загружаться из JSON
final String jsonData = '''
{
  "products": [
    {
      "ID": 1,
      "Name": "Домашняя форма сезон 2024/25",
      "Description": "Домашняя форма команды ПФК ЦСКА на сезон 2024/25",
      "Price": 6500,
      "ImageURL": "assets/images/home_24-25.png"
    },
    {
      "ID": 2,
      "Name": "Гостевая форма сезон 2024/25",
      "Description": "Гостевая форма команды ПФК ЦСКА на сезон 2024/25",
      "Price": 6500,
      "ImageURL": "assets/images/away_24-25.png"
    },
    {
      "ID": 3,
      "Name": "Резервная форма сезон 2024/25",
      "Description": "Резервная форма команды ПФК ЦСКА на сезон 2024/25",
      "Price": 6500,
      "ImageURL": "assets/images/res_24-25.png"
    },
    {
      "ID": 4,
      "Name": "Домашняя форма сезон 2023/24",
      "Description": "Домашняя форма команды ПФК ЦСКА на сезон 2023/24",
      "Price": 8000,
      "ImageURL": "assets/images/home_23-24.png"
    },
    {
      "ID": 5,
      "Name": "Гостевая форма сезон 2023/24",
      "Description": "Гостевая форма команды ПФК ЦСКА на сезон 2023/24",
      "Price": 8000,
      "ImageURL": "assets/images/away_23-24.png"
    },
    {
      "ID": 6,
      "Name": "Домашняя форма сезон 2022/23",
      "Description": "Домашняя форма команды ПФК ЦСКА на сезон 2022/23",
      "Price": 10000,
      "ImageURL": "assets/images/home_22-23.png"
    },
    {
      "ID": 7,
      "Name": "Гостевая форма сезон 2022/23",
      "Description": "Гостевая форма команды ПФК ЦСКА на сезон 2022/23",
      "Price": 10000,
      "ImageURL": "assets/images/away_22-23.png"
    },
    {
      "ID": 8,
      "Name": "Домашняя форма сезон 2021/22",
      "Description": "Домашняя форма команды ПФК ЦСКА на сезон 2021/22",
      "Price": 11500,
      "ImageURL": "assets/images/home_21-22.png"
    },
    {
      "ID": 9,
      "Name": "Гостевая форма сезон 2021/22",
      "Description": "Гостевая форма команды ПФК ЦСКА на сезон 2021/22",
      "Price": 11500,
      "ImageURL": "assets/images/away_21-22.png"
    }
  ]
}
''';

// Инициализация демо-продуктов из JSON
final List<Product> demoProducts = loadProductsFromJson(jsonData); 