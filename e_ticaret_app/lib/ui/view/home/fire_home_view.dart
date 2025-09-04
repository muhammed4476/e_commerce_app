import 'dart:async';
import 'dart:ffi';

import 'package:e_ticaret_app/core/color/color.dart';
import 'package:e_ticaret_app/core/font_family/font_family.dart';
import 'package:e_ticaret_app/core/margin/margin.dart';
import 'package:e_ticaret_app/core/model/category_product_list/api_service.dart';

import 'package:e_ticaret_app/core/model/category_product_list/globals.dart';
import 'package:e_ticaret_app/core/model/category_product_list/product.dart';
import 'package:e_ticaret_app/core/padding/padding.dart';
import 'package:e_ticaret_app/core/sized_box/sized_box.dart';
import 'package:e_ticaret_app/ui/view/home/category_page.dart';
import 'package:e_ticaret_app/ui/view/home/product_detail.dart';
import 'package:e_ticaret_app/ui/view/home/product_view.dart';
import 'package:e_ticaret_app/ui/view/home/sepet_page.dart';
import 'package:e_ticaret_app/ui/view/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class FireHomeView extends StatefulWidget {
  const FireHomeView({super.key});

  @override
  State<FireHomeView> createState() => _FireHomeViewState();
}

class _FireHomeViewState extends State<FireHomeView> {
  final String appBarTittle = "everest";
  final String appBarSubtitle = "WHAT'S YOUR E_COMMARCE";
  final String category = "Category";
  final String sepet = "Sepet";
  final String settings = "Settings";
  final String error = "Error";
  final String categoryler = "Categoryler";
  final String dealOfTheDay = "Deal of the Day";
  final String calibreDeal = "Calibre Deal";
  final String coksatnalar = "Çok Satanlar";
  final String logoURL = "assets/png/logo1.png";

  bool isLoading = true;

  List<double> priceList = [15000.98, 78000.98, 101000.98];
  List<Product> productList = [];
  late Timer _timer;
  late Duration _remaining;
  bool ontap = true;

  // GlobalKey ile Scaffold'ı kontrol ediyoruz
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _remaining = Duration(hours: 3, minutes: 24, seconds: 15);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining = _remaining - Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    ApiService apiService = ApiService();
    try {
      final categories = await apiService.fetchCategories();
      List<Product> tempProductList = [];

      setState(() {
        productList = tempProductList;
        globalCategories = categories;
        isLoading = false;
      });
      for (var cat in categories) {
        if (cat.products.isNotEmpty) {
          tempProductList.addAll(cat.products);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(error + e.toString());
    }
  }

  final List<String> imageUrls = ['assets/png/ev.jpg', 'assets/png/spor.jpg', 'assets/png/teklonoji.jpg'];

  String truncateAfterWords(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length <= wordLimit) return text;
    return '${words.sublist(0, wordLimit).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> bestSellers = [];

    void addProductIfExists(int categoryIndex, int productIndex) {
      if (globalCategories.length > categoryIndex) {
        final category = globalCategories[categoryIndex];
        if (category.products.length > productIndex) {
          bestSellers.add(category.products[productIndex]);
        }
      }
    }

    // Kullanımı:
    addProductIfExists(0, 3);
    addProductIfExists(1, 3);
    addProductIfExists(2, 3);
    addProductIfExists(0, 4);
    addProductIfExists(1, 2);

    // İstersen buraya başka ürünler de ekleyebilirsin

    String hours = _remaining.inHours.toString().padLeft(2, '0');
    String minutes = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      key: _scaffoldKey, // GlobalKey ekliyoruz
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [appbarTittleMethod(context, 25, 30, 50), appbarTextMethod(context, 12)],
        ),
        actions: [
          CustomIconButton(icon: HugeIcons.strokeRoundedNotification01),
          CustomIconButton(icon: HugeIcons.strokeRoundedShoppingBag01),
        ],
        leading: CustomIconButton(
          icon: HugeIcons.strokeRoundedMenu04,
          onPressed: () {
            // Drawer'ı açmak için _scaffoldKey kullanıyoruz
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: ListView(
          padding: CustomPadding.zeroPadding,
          children: <Widget>[
            DrawerHeader(
              margin: CustomMargin.zeroMargin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [appbarTittleMethod(context, 35, 60, 80), appbarTextMethod(context, 18)],
              ),
            ),

            Card(
              shadowColor: CostumColor.blue900,
              margin: CustomMargin.zeroMargin,
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                leading: Icon(Icons.category_outlined, color: CostumColor.red),
                title: Text(
                  category,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: CustomFontFamily.storyScript,
                    color: CostumColor.blue900,
                  ),
                ),
                trailing: Icon(ontap ? Icons.expand_less : Icons.expand_more),
                onTap: () {
                  setState(() {
                    ontap = !ontap;
                  });
                },
              ),
            ),

            // ALT KATEGORİLER
            if (ontap)
              ...globalCategories.map((category) {
                return Padding(
                  padding: CustomPadding.leftPadding40,
                  child: Container(
                    margin: CustomMargin.vertical5,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: CostumColor.grey600)),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        category.image,
                        fit: BoxFit.contain,
                        width: CustomSizedBox.width50,
                        height: CustomSizedBox.height40,
                      ),
                      title: Text(
                        category.name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontFamily: CustomFontFamily.storyScript, fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pop(context); // Drawer'ı kapat
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                      },
                    ),
                  ),
                );
              }),
            CostumDrawerCardWidget(
              sepet: sepet,
              icon: HugeIcons.strokeRoundedShoppingBasket01,
              navigateTo: const SepetPage(),
            ),
            CostumDrawerCardWidget(
              sepet: settings,
              icon: HugeIcons.strokeRoundedSettings01,
              navigateTo: const SettingsPage(),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SizedBox(
                  height: CustomSizedBox.height230,
                  child: PageView.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Image.asset(imageUrls[index], fit: BoxFit.fill);
                    },
                  ),
                ),
                Padding(
                  padding: CustomPadding.leftPadding10 + CustomPadding.topPadding15 + CustomPadding.rightPadding300,
                  child: Container(
                    width: CustomSizedBox.width300,
                    decoration: BoxDecoration(color: CostumColor.blue900, borderRadius: BorderRadius.circular(5)),

                    child: Padding(
                      padding: CustomPadding.horizontalPadding10,
                      child: Text(
                        categoryler,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: CostumColor.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: CustomPadding.verticalPadding15,
                  child: SizedBox(
                    height: CustomSizedBox.height140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,

                      itemCount: globalCategories.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: CustomSizedBox.width130,
                          child: InkWell(
                            child: Card(
                              margin: CustomMargin.horizontal10,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: CostumColor.grey300, width: 5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: CostumColor.grey100,

                              child: Padding(
                                padding: CustomPadding.paddingAll8,
                                child: Column(
                                  // Yazıları sola yaslar
                                  children: [
                                    Center(
                                      // Resmi ortalar
                                      child: Container(
                                        width: CustomSizedBox.width80,
                                        height: CustomSizedBox.height80,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: CostumColor.grey300),
                                        child: Center(
                                          child: Image.asset(
                                            globalCategories[index].image,
                                            fit: BoxFit.contain,
                                            width: CustomSizedBox.width50,
                                            height: CustomSizedBox.height50,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: CustomPadding.verticalPadding10,
                                      child: Text(
                                        globalCategories[index].name,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPageView(category: globalCategories[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: CustomPadding.horizontalPadding10,
                  child: SizedBox(
                    height: CustomSizedBox.height240,

                    child: Card(
                      margin: CustomMargin.zeroMargin,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: CostumColor.grey300, width: 5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: CostumColor.grey100,
                      child: PageView(
                        children: [
                          InkWell(
                            child: Padding(
                              padding: CustomPadding.horizontalPadding10 + CustomPadding.verticalPadding10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      container(context, dealOfTheDay),
                                      Spacer(),
                                      CostumRedCard(data: hours),
                                      CostumRedCard(data: minutes),
                                      CostumRedCard(data: seconds),
                                    ],
                                  ),

                                  costumBlueLogoCard(tittle: calibreDeal),

                                  // ✅ Expanded doğru yerde
                                  pageViewImageContainer(productList[0].images[0]),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      namePageViewMethod(context, productList[0].name),
                                      Row(
                                        children: [
                                          priceMethod(context, "${priceList[0]}"),
                                          Padding(
                                            padding: CustomPadding.horizontalPadding10,
                                            child: salePriceMethod(context, "${productList[0].price}"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProductDetail(product: productList[0])),
                              );
                            },
                          ),
                          InkWell(
                            child: Padding(
                              padding: CustomPadding.horizontalPadding10 + CustomPadding.verticalPadding10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      container(context, dealOfTheDay),
                                      Spacer(),
                                      CostumRedCard(data: hours),
                                      CostumRedCard(data: minutes),
                                      CostumRedCard(data: seconds),
                                    ],
                                  ),

                                  costumBlueLogoCard(tittle: calibreDeal),

                                  // ✅ Expanded doğru yerde
                                  pageViewImageContainer(productList[6].images[0]),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      namePageViewMethod(context, productList[6].name),
                                      Row(
                                        children: [
                                          priceMethod(context, "${priceList[1]}"),
                                          Padding(
                                            padding: CustomPadding.horizontalPadding10,
                                            child: salePriceMethod(context, "${productList[6].price}"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProductDetail(product: productList[6])),
                              );
                            },
                          ),
                          InkWell(
                            child: Padding(
                              padding: CustomPadding.verticalPadding10 + CustomPadding.horizontalPadding10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      container(context, dealOfTheDay),
                                      Spacer(),
                                      CostumRedCard(data: hours),
                                      CostumRedCard(data: minutes),
                                      CostumRedCard(data: seconds),
                                    ],
                                  ),

                                  costumBlueLogoCard(tittle: calibreDeal),

                                  // ✅ Expanded doğru yerde
                                  pageViewImageContainer(productList[5].images[0]),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      namePageViewMethod(context, productList[5].name),
                                      Row(
                                        children: [
                                          priceMethod(context, "${priceList[2]}"),
                                          Padding(
                                            padding: CustomPadding.horizontalPadding10,
                                            child: salePriceMethod(context, "${productList[5].price}"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProductDetail(product: productList[5])),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: CustomPadding.leftPadding10 + CustomPadding.rightPadding300 + CustomPadding.topPadding15,
                  child: Container(
                    width: CustomSizedBox.width300,
                    decoration: BoxDecoration(color: CostumColor.blue900, borderRadius: BorderRadius.circular(5)),

                    child: Padding(
                      padding: CustomPadding.horizontalPadding10,
                      child: Text(
                        coksatnalar,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: CostumColor.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: CustomPadding.verticalPadding15,
                  child: SizedBox(
                    height: CustomSizedBox.height210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,

                      itemCount: bestSellers.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: CustomSizedBox.width150,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: CostumColor.grey300, width: 5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: CostumColor.grey100,
                            margin: CustomMargin.horizontal10,
                            child: Padding(
                              padding: CustomPadding.paddingAll10,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProductDetail(product: bestSellers[index])),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Yazıları sola yaslar
                                  children: [
                                    Center(
                                      // Resmi ortalar
                                      child: Image.asset(
                                        bestSellers[index].images[0],
                                        fit: BoxFit.contain,
                                        width: CustomSizedBox.width150,
                                        height: CustomSizedBox.height100,
                                      ),
                                    ),
                                    Padding(
                                      padding: CustomPadding.verticalPadding5,
                                      child: Text(
                                        truncateAfterWords(bestSellers[index].name, 2),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall?.copyWith(color: CostumColor.grey600),
                                      ),
                                    ),
                                    Text(
                                      "\$${bestSellers[index].price}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall?.copyWith(color: CostumColor.blue900),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Text appbarTextMethod(BuildContext context, double? fontSize) {
    return Text(
      appBarSubtitle,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: CustomFontFamily.storyScript,
        color: CostumColor.red,
        fontSize: fontSize,
      ),
    );
  }

  Row appbarTittleMethod(BuildContext context, double? fontSize, double? height, double? width) {
    return Row(
      children: [
        Image.asset(logoURL, height: height, width: width, fit: BoxFit.cover),
        Expanded(
          child: Text(
            appBarTittle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: CustomFontFamily.archivoBlack,
              color: CostumColor.blue900,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }

  Text namePageViewMethod(BuildContext context, String name) {
    return Text(
      truncateAfterWords(name, 4),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: CostumColor.grey600),
    );
  }

  Text salePriceMethod(BuildContext context, String price) {
    return Text("\$$price", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: CostumColor.blue900));
  }

  Text priceMethod(BuildContext context, String price) {
    return Text(
      "\$$price",

      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: CostumColor.red,
        decoration: TextDecoration.lineThrough,
        decorationColor: CostumColor.red, // ✅ çizgi rengi
        decorationThickness: 2,
      ),
    );
  }

  Center pageViewImageContainer(String imagePath) {
    return Center(
      child: Container(
        height: CustomSizedBox.height120,
        width: CustomSizedBox.width340,
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }

  Container container(BuildContext context, String tittle) {
    return Container(
      child: Text(
        tittle,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}

class CostumDrawerCardWidget extends StatelessWidget {
  const CostumDrawerCardWidget({super.key, required this.sepet, required this.icon, required this.navigateTo});

  final String sepet;
  final IconData icon;
  final Widget navigateTo;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: CostumColor.blue900,
      margin: CustomMargin.zeroMargin,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
        leading: Icon(icon, color: CostumColor.red),
        title: Text(
          sepet,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontFamily: CustomFontFamily.storyScript, color: CostumColor.blue900),
        ),
        onTap: () {
          // Profil sayfasına gitmek için kod ekleyebilirsiniz
          Navigator.push(context, MaterialPageRoute(builder: (context) => navigateTo));
        },
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({super.key, required this.icon, this.onPressed = _defaultOnPressed});

  static void _defaultOnPressed() {}

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(icon));
  }
}

class costumBlueLogoCard extends StatelessWidget {
  const costumBlueLogoCard({super.key, required this.tittle});
  final String tittle;
  final String logoURL = "assets/png/logo1.png";

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: CustomMargin.zeroMargin,
      color: CostumColor.blue900,
      shape: StadiumBorder(),
      child: Padding(
        padding: CustomPadding.horizontalPadding10,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: CustomSizedBox.width30,
              height: CustomSizedBox.height18,
              child: Image.asset(logoURL, fit: BoxFit.cover),
            ),
            SizedBox(width: 8),
            Text(tittle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CostumColor.white)),
          ],
        ),
      ),
    );
  }
}

class CostumRedCard extends StatelessWidget {
  const CostumRedCard({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: CustomMargin.left10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: CostumColor.red,
      child: Padding(padding: CustomPadding.paddingAll5, child: Text(data)),
    );
  }
}
