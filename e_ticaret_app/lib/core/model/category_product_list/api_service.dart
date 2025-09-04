import 'dart:convert';

import 'package:e_ticaret_app/core/model/category_product_list/category.dart';
import 'package:e_ticaret_app/core/model/category_product_list/product.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse("http://10.0.2.2/myapi/get_categories.php"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception("Veri alınamadı");
    }
  }

  Future<List<Product>> fetchProducts() async {
    final categories = await fetchCategories();
    List<Product> productList = [];
    for (var cat in categories) {
      if (cat.products.isNotEmpty) {
        productList.addAll(cat.products);
      }
    }
    return productList;
  }
}
