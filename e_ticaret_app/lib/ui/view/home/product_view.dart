import 'package:e_ticaret_app/core/color/color.dart';
import 'package:e_ticaret_app/core/model/category_product_list/category.dart';
import 'package:e_ticaret_app/core/model/category_product_list/product.dart';
import 'package:e_ticaret_app/core/padding/padding.dart';
import 'package:e_ticaret_app/core/sized_box/sized_box.dart';
import 'package:e_ticaret_app/ui/view/home/product_detail.dart';
import 'package:flutter/material.dart';

class ProductPageView extends StatelessWidget {
  final Category category;

  const ProductPageView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: Padding(
        padding: CustomPadding.paddingAll10,
        child: ListView.builder(
          itemCount: category.products.length,
          itemBuilder: (context, index) {
            final pro = category.products[index];
            return Card(
              color: CostumColor.grey100,
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedBorderMethod(),
              child: ListTile(
                contentPadding: CustomPadding.paddingAll12,
                leading: cliparectMethod(pro),
                title: Text(pro.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(pro.description, maxLines: 4, style: TextStyle(color: CostumColor.grey600)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: pro)));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  RoundedRectangleBorder RoundedBorderMethod() {
    return RoundedRectangleBorder(
      side: BorderSide(color: CostumColor.grey300, width: 5),
      borderRadius: BorderRadius.circular(12),
    );
  }

  ClipRRect cliparectMethod(Product pro) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        pro.images[0],
        width: CustomSizedBox.width60,
        height: CustomSizedBox.height60,
        fit: BoxFit.contain,
      ),
    );
  }
}
