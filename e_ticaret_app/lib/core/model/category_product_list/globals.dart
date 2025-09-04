import 'package:e_ticaret_app/core/model/category_product_list/cart_item.dart';
import 'package:e_ticaret_app/core/model/category_product_list/category.dart';

import 'package:flutter/foundation.dart' hide Category;

// Global kategoriler listesi
List<Category> globalCategories = [];

// Sepetteki ürünleri tutan ValueNotifier
// Sepet içeriği değiştiğinde dinleyiciler otomatik güncellenir
ValueNotifier<List<CartItem>> cartItemsNotifier = ValueNotifier([]);
