import 'package:flutter/material.dart';
import 'package:ryan_store_app/views/screens/nav_screens/account_screen.dart';
import 'package:ryan_store_app/views/screens/nav_screens/cart_screen.dart';
import 'package:ryan_store_app/views/screens/nav_screens/favorite_screen.dart';
import 'package:ryan_store_app/views/screens/nav_screens/home_screen.dart';
import 'package:ryan_store_app/views/screens/nav_screens/stores_screen.dart';

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    FavoriteScreen(),
    StoresScreen(),
    CartScreen(),
    AccountScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Image.asset('assets/icons/home3.png', width: 25,), label: 'Home'),
          BottomNavigationBarItem(icon: Image.asset('assets/icons/heart1.png', width: 25,), label: 'Favorite'),
          BottomNavigationBarItem(icon: Image.asset('assets/icons/shop.png', width: 25,), label: 'Stores'),
          BottomNavigationBarItem(icon: Image.asset('assets/icons/shopping-cart1.png', width: 25,), label: 'Cart'),
          BottomNavigationBarItem(icon: Image.asset('assets/icons/user5.png', width: 25,), label: 'Account'),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
