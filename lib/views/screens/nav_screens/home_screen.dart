import 'package:flutter/material.dart';
import 'package:ryan_store_app/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:ryan_store_app/views/screens/nav_screens/widgets/category_item.dart';
import 'package:ryan_store_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:ryan_store_app/views/screens/nav_screens/widgets/recommended_product_widget.dart';
import 'package:ryan_store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
            BannerWidget(),
            CategoryItem(),
            ReusableTextWidget(title: 'Recommended For You', subtitle: 'View all'),
            RecommendedProductWidget(),
            ReusableTextWidget(title: 'Popular Products', subtitle: 'View all'),
          ],
        ),
      ),
    );
  }
}
