import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ryan_store_app/provider/cart_provider.dart';
import 'package:ryan_store_app/provider/favorite_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    final favoriteProiderData = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);
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
              onPressed: () {
                favoriteProiderData.addProductToFavorite(
                  productName: widget.productData['productName'],
                  productId: widget.productData['productId'],
                  imageUrl: widget.productData['productImages'],
                  productPrice: widget.productData['productPrice'],
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    margin: EdgeInsets.all(15),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.grey,
                    content: Text(widget.productData['productName']),
                  ),
                );

              },
              icon:
                  favoriteProiderData.getFavoriteItem.containsKey(
                        widget.productData['productId'],
                      )
                      ? Icon(Icons.favorite, color: Colors.redAccent)
                      : Icon(Icons.favorite_border, color: Colors.redAccent,),
            ),
          ],
        ),
        // iconTheme: IconThemeData(color: Colors.pink),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 260,
              height: 274,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 50,
                    child: Container(
                      width: 260,
                      height: 260,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Color(0xffd8ddff),
                        borderRadius: BorderRadius.circular(130),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    top: 0,
                    child: Container(
                      width: 216,
                      height: 274,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Color(0xff9ca8ff),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: SizedBox(
                        height: 300,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.productData['productImages'].length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              widget.productData['productImages'][index],
                              width: 198,
                              height: 225,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.productData['productName'],
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Color(0xff3c55ef),
                  ),
                ),
                Text(
                  '\$${widget.productData['productPrice'].toStringAsFixed(2)}',
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Color(0xff3c55ef),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productData['category'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Size',
                  style: GoogleFonts.lato(
                    color: Color(0xff343434),
                    fontSize: 16,
                    letterSpacing: 1.6,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productData['productSize'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff126881),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                widget.productData['productSize'][index],
                                style: GoogleFonts.lato(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.lato(
                    color: Color(0xff363330),
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                Text(widget.productData['description']),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            cartProviderData.addProductToCart(
              productName: widget.productData['productName'],
              productPrice: widget.productData['productPrice'],
              categoryName: widget.productData['category'],
              imageUrl: widget.productData['productImages'],
              quantity: 1,
              instock: widget.productData['quantity'],
              productId: widget.productData['productId'],
              productSize: '',
              discount: widget.productData['discount'],
              description: widget.productData['description'],
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                margin: EdgeInsets.all(15),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.grey,
                content: Text(widget.productData['productName']),
              ),
            );
          },
          child: Container(
            width: 386,
            height: 48,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Color(0xff3b54ee),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'ADD TO CART',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
