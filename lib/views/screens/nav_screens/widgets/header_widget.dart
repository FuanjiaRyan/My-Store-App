import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/banner.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 48,
            top: 40,
            child: SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter text',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xff7f7f7f)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Image.asset(
                      'assets/icons/search7.png',
                      color: Color(0xff7f7f7f),
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Image.asset(
                      'assets/icons/camera.png',
                      color: Color(0xff7f7f7f),
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  focusColor: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            left: 311,
            top: 50,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                child: Ink(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/bell-ring.png'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
