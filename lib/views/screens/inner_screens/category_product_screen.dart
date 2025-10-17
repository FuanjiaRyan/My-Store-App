import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryan_store_app/models/category_models.dart';
import '../nav_screens/widgets/popularItem.dart';

class CategoryProductScreen extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryProductScreen({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream =
        FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: categoryModel.categoryName)
            .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryModel.categoryName,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                'No products under this category\ncheck back later',
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


