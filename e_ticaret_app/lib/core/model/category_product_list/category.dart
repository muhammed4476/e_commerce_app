import 'product.dart';

class Category {
  final int id;
  final String name;
  final String image;
  final List<Product> products;
  final String subName; // ✅ Yeni alan

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.products,
    required this.subName, // ✅ Constructor'a eklendi
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<Product> productsList = list.map((i) => Product.fromJson(i)).toList();

    return Category(
      id: int.parse(json['id']),
      name: json['name'],
      image: json['image'],
      products: productsList,
      subName: json['subName'] ?? "", // ✅ JSON'dan alınan yeni alan (null'a karşı korunmalı)
    );
  }
}
