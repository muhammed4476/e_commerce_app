import 'package:e_ticaret_app/core/color/color.dart';
import 'package:e_ticaret_app/core/font_family/font_family.dart';
import 'package:e_ticaret_app/core/margin/margin.dart';
import 'package:e_ticaret_app/core/model/category_product_list/product.dart';
import 'package:e_ticaret_app/core/padding/padding.dart';
import 'package:e_ticaret_app/core/sized_box/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:e_ticaret_app/core/model/category_product_list/globals.dart';
import 'package:hugeicons/hugeicons.dart';

class SepetPage extends StatefulWidget {
  const SepetPage({super.key});

  @override
  State<SepetPage> createState() => _SepetPageState();
}

class _SepetPageState extends State<SepetPage> {
  final String sepet = "Sepet";
  final String sepetB = "Sepet boş";
  @override
  void initState() {
    super.initState();
    cartItemsNotifier.addListener(_update);
  }

  @override
  void dispose() {
    cartItemsNotifier.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = cartItemsNotifier.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          sepet,

          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontFamily: CustomFontFamily.storyScript, color: CostumColor.red),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text(sepetB))
          : ListView.builder(
              padding: CustomPadding.paddingAll12,
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                final product = cartItem.product;

                return Card(
                  color: CostumColor.grey100,
                  margin: CustomMargin.vertical8,
                  elevation: 4,
                  shape: roundenBorderMethod(),
                  child: Padding(
                    padding: CustomPadding.paddingAll12,
                    child: Row(
                      children: [
                        // Ürün görseli
                        cliprectMEthod(product),
                        SizedBox(width: CustomSizedBox.width16),

                        // Ürün detayları
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NameTextWidget(product: product),
                              SizedBox(height: CustomSizedBox.height6),
                              PriceTExtWidget(product: product),
                            ],
                          ),
                        ),

                        // + / - butonları
                        Row(
                          children: [
                            CustomIconButton(
                              icon: Icons.remove_circle_outline,
                              onPressed: () {
                                setState(() {
                                  if (cartItem.quantity > 1) {
                                    cartItem.quantity--;
                                  } else {
                                    cartItems.removeAt(index);
                                  }
                                  cartItemsNotifier.notifyListeners();
                                });
                              },
                            ),
                            Text(cartItem.quantity.toString(), style: const TextStyle(fontSize: 16)),
                            CustomIconButton(
                              icon: Icons.add_circle_outline,
                              onPressed: () {
                                setState(() {
                                  cartItem.quantity++;
                                  cartItemsNotifier.notifyListeners();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  ClipRRect cliprectMEthod(Product product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        product.images[0],
        width: CustomSizedBox.width80,
        height: CustomSizedBox.height80,
        fit: BoxFit.contain,
      ),
    );
  }

  RoundedRectangleBorder roundenBorderMethod() {
    return RoundedRectangleBorder(
      side: BorderSide(color: CostumColor.grey300, width: 5),
      borderRadius: BorderRadius.circular(12),
    );
  }
}

class PriceTExtWidget extends StatelessWidget {
  const PriceTExtWidget({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text("${product.price.toStringAsFixed(2)} ₺", style: TextStyle(fontSize: 14, color: CostumColor.grey600));
  }
}

class NameTextWidget extends StatelessWidget {
  const NameTextWidget({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text(product.name, maxLines: 2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const CustomIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon), onPressed: onPressed);
  }
}
