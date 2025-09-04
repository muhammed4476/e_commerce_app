import 'package:e_ticaret_app/core/model/category_product_list/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
