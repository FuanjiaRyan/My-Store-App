import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ryan_store_app/vendor/views/screens/bottomNavigationBar/earnings_screen.dart';
import 'package:ryan_store_app/vendor/views/screens/bottomNavigationBar/edit_product_screen.dart';
import 'package:ryan_store_app/vendor/views/screens/bottomNavigationBar/upload_product_screen.dart';
import 'package:ryan_store_app/vendor/views/screens/bottomNavigationBar/vendor_order_screen.dart';
import 'package:ryan_store_app/vendor/views/screens/bottomNavigationBar/vendor_profile_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int pageIndex = 0;
  final List<Widget> _pages = [
    EarningsScreen(),
    UploadProductScreen(),
    VendorOrderScreen(),
    EditProductScreen(),
    VendorProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.upload_circle),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
