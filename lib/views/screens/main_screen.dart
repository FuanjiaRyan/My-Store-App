import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Image.asset('assets/icons/home3.png', width: 25,), label: 'Home'),
          BottomNavigationBarItem(icon: Image.asset('assets/icons/heart1.png', width: 25,), label: 'Favorite'),
          BottomNavigationBarItem(icon: Image.asset('assets/icons/shop.png', width: 25,), label: 'Stores'),
          BottomNavigationBarItem(icon: Image.asset('assets/icons/shopping-cart1.png', width: 25,), label: 'Cart'),
          BottomNavigationBarItem(icon: Image.asset('assets/icons/user5.png', width: 25,), label: 'Account'),

        ],
      ),
    );
  }
}
