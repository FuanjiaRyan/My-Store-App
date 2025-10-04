import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height *0.20,
      child: Stack(
        children: [
          Image.asset('assets/images/banner.png'),
        ],
      ),
    );
  }
}
