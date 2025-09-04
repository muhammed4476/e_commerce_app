import 'package:e_ticaret_app/core/color/color.dart';
import 'package:e_ticaret_app/core/margin/margin.dart';
import 'package:e_ticaret_app/core/model/category_product_list/api_service.dart';
import 'package:e_ticaret_app/core/model/category_product_list/category.dart';
import 'package:e_ticaret_app/core/model/category_product_list/globals.dart';
import 'package:e_ticaret_app/core/padding/padding.dart';
import 'package:e_ticaret_app/core/sized_box/sized_box.dart';
import 'package:e_ticaret_app/ui/view/home/product_view.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isLoading = true;
  final String title = "Categories";

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    ApiService apiService = ApiService();
    try {
      final categories = await apiService.fetchCategories();
      setState(() {
        globalCategories = categories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: CustomPadding.paddingAll10,
              child: ListView.builder(
                itemCount: globalCategories.length,
                itemBuilder: (context, index) {
                  final category = globalCategories[index];
                  return Card(
                    color: CostumColor.grey100,
                    elevation: 3,
                    margin: CustomMargin.vertical8,
                    shape: shapeBorderMethod(),
                    child: ListTile(
                      contentPadding: CustomPadding.paddingAll10,
                      leading: borderRadiusMethod(category),
                      title: TextWidget(category: category),
                      subtitle: Subtitlewidget(category: category),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        pushMethod(context, index);
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  void pushMethod(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductPageView(category: globalCategories[index])),
    );
  }

  ClipRRect borderRadiusMethod(Category category) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        category.image,
        width: CustomSizedBox.width60,
        height: CustomSizedBox.height60,
        fit: BoxFit.contain,
      ),
    );
  }

  RoundedRectangleBorder shapeBorderMethod() {
    return RoundedRectangleBorder(
      side: BorderSide(color: CostumColor.grey300, width: 5),
      borderRadius: BorderRadius.circular(12),
    );
  }
}

class Subtitlewidget extends StatelessWidget {
  const Subtitlewidget({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Text(category.subName, style: TextStyle(color: Colors.grey.shade600));
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }
}
