import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Detail',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: Color(0xff363330),
                fontSize: 18,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite, color: Colors.redAccent),
            ),
          ],
        ),
        // iconTheme: IconThemeData(color: Colors.pink),
      ),
    );
  }
}
