import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../nav_screens/widgets/popularItem.dart';

class InnerVendorProductScreen extends StatefulWidget {
  final String vendorId;

  const InnerVendorProductScreen({super.key, required this.vendorId});

  @override
  State<InnerVendorProductScreen> createState() =>
      _InnerVendorProductScreenState();
}

class _InnerVendorProductScreenState extends State<InnerVendorProductScreen> {
  late Stream<QuerySnapshot> _productStream;

  @override
  void initState() {
    super.initState();
    _productStream =
        FirebaseFirestore.instance
            .collection('products')
            .where('vendorId', isEqualTo: widget.vendorId)
            .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                textAlign: TextAlign.center,
                'No products under this vendor\ncheck back later',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.7,
                ),
              ),
            );
          }

          return GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            shrinkWrap: true,
            childAspectRatio: 300 / 500,
            physics: ScrollPhysics(),
            children: List.generate(snapshot.data!.size, (index) {
              final productData = snapshot.data!.docs[index];
              return PopularItem(productData: productData);
            }),
          );
        },
      ),
    );
  }
}
