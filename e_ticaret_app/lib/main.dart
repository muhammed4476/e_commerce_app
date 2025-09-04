import 'package:e_ticaret_app/core/color/color.dart';
import 'package:e_ticaret_app/core/font_family/font_family.dart';
import 'package:e_ticaret_app/ui/view/authentication/login_first.dart';
import 'package:e_ticaret_app/ui/view/home/category_page.dart';
import 'package:e_ticaret_app/ui/view/home/fire_home_view.dart';

import 'package:e_ticaret_app/ui/view/home/sepet_page.dart';
import 'package:e_ticaret_app/ui/view/home/settings_page.dart';

import 'package:flutter/material.dart';
import 'package:global_bottom_navigation_bar/widgets/bottom_navigation_item.dart';
import 'package:global_bottom_navigation_bar/widgets/scaffold_bottom_navigation.dart';
import 'package:hugeicons/hugeicons.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: CustomFontFamily.storyScript,
            color: CostumColor.red,
            fontSize: 20, // headlineSmall'a yakın değer
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      debugShowCheckedModeBanner: false,
      home: LoginFirst(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final String shop = "Shop";
  final String category = "Category";
  final String basket = "Basket";
  final String settings = "Settings";
  @override
  Widget build(BuildContext context) {
    return ScaffoldGlobalBottomNavigation(
      listOfChild: [FireHomeView(), CategoryPage(), SepetPage(), SettingsPage()],
      listOfBottomNavigationItem: buildBottomNavigationItemList(),
    );
  }

  List<BottomNavigationItem> buildBottomNavigationItemList() => [
    BottomNavigationItem(
      activeIcon: Icon(HugeIcons.strokeRoundedShoppingBag01, color: Colors.red, size: 18),
      inActiveIcon: Icon(HugeIcons.strokeRoundedShoppingBag01, color: Colors.white, size: 21),
      title: shop,
      color: Colors.blue.shade900,
      vSync: this,
    ),
    BottomNavigationItem(
      activeIcon: Icon(Icons.category_outlined, color: Colors.red, size: 18),
      inActiveIcon: Icon(Icons.category_outlined, color: Colors.white, size: 21),
      title: category,
      color: Colors.blue.shade900,
      vSync: this,
    ),
    BottomNavigationItem(
      activeIcon: Icon(HugeIcons.strokeRoundedShoppingBasket01, color: Colors.red, size: 18),
      inActiveIcon: Icon(HugeIcons.strokeRoundedShoppingBasket01, color: Colors.white, size: 21),
      title: basket,
      color: Colors.blue.shade900,
      vSync: this,
    ),
    BottomNavigationItem(
      activeIcon: Icon(HugeIcons.strokeRoundedSettings02, color: Colors.red, size: 18),
      inActiveIcon: Icon(HugeIcons.strokeRoundedSettings02, color: Colors.white, size: 21),
      title: settings,
      color: Colors.blue.shade900,
      vSync: this,
    ),
  ];
}
