import 'package:e_ticaret_app/core/color/color.dart';
import 'package:e_ticaret_app/core/font_family/font_family.dart';
import 'package:e_ticaret_app/core/margin/margin.dart';
import 'package:e_ticaret_app/core/padding/padding.dart';
import 'package:e_ticaret_app/core/sized_box/sized_box.dart';
import 'package:e_ticaret_app/ui/view/home/sepet_page.dart';
import 'package:flutter/material.dart';
import 'package:e_ticaret_app/core/model/category_product_list/product.dart';
import 'package:e_ticaret_app/core/model/category_product_list/globals.dart';
import 'package:e_ticaret_app/core/model/category_product_list/cart_item.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // CartItem modelini import et

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final String appbarTitle = "Product Detail Page";
  final String text = "Şimdi Al";
  final String text2 = "Sepete Eklendi";
  final String text3 = "Sepete Ekle";
  final String descriptionText = "Description";
  void addToCart(Product product) {
    final cartItems = cartItemsNotifier.value;

    // Aynı ürün sepette var mı kontrol et
    final index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // Varsa adeti artır
      cartItems[index].quantity++;
    } else {
      // Yoksa yeni ürün olarak ekle
      cartItems.add(CartItem(product: product));
    }

    cartItemsNotifier.notifyListeners();
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
        centerTitle: true,
        leading: Padding(
          padding: CustomPadding.leftPadding15,
          child: Center(
            child: CostumIconButton(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),

        actions: [
          Padding(
            padding: CustomPadding.horizontalPadding15,
            child: CostumIconButton(
              icon: HugeIcons.strokeRoundedShoppingBasket01,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SepetPage()));
              },
            ),
          ),
        ],
      ),

      // ✅ ALTTAKİ BUTONLAR BURAYA TAŞINDI
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                "\$${product.price}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              flex: 2,
              child: CustomButton(
                text: text,
                onPressed: () {
                  addToCart(product);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SepetPage()));
                },
                color: CostumColor.red,
              ),
            ),

            SizedBox(width: CustomSizedBox.width10),
            Expanded(
              flex: 4,
              child: CustomButton(
                text: text3,
                onPressed: () {
                  addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${product.name} $text2")));
                },
                color: CostumColor.blue900,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: CustomPadding.horizontalPadding15,
        child: ListView(
          children: [
            SizedBox(
              height: CustomSizedBox.height300,
              child: Container(
                margin: CustomMargin.vertical15,
                decoration: BoxDecoration(
                  color: CostumColor.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CostumColor.grey100, width: CustomSizedBox.width10),
                ),
                child: PageView(
                  controller: _pageController,
                  children: [
                    for (var image in product.images)
                      Padding(
                        padding: CustomPadding.paddingAll8,
                        child: Image.asset(image, fit: BoxFit.contain),
                      ),
                  ],
                ),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.product.images.length,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 8,
                  activeDotColor: CostumColor.blue900,
                  dotColor: CostumColor.grey100,
                ),
              ),
            ),
            Padding(
              padding: CustomPadding.verticalPadding15,
              child: Card(
                color: CostumColor.grey100,
                margin: CustomMargin.zeroMargin,
                child: Padding(
                  padding: CustomPadding.paddingAll8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: CostumColor.blue900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              descriptionText,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontFamily: CustomFontFamily.storyScript, color: CostumColor.red),
            ),
            Card(
              color: CostumColor.grey100,
              margin: CustomMargin.vertical10,
              child: Padding(padding: CustomPadding.paddingAll8, child: Text(product.description)),
            ),
          ],
        ),
      ),
    );
  }
}

class CostumIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const CostumIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon), onPressed: onPressed);
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const CustomButton({super.key, required this.text, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: CustomPadding.verticalPadding15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: CostumColor.white)),
    );
  }
}
