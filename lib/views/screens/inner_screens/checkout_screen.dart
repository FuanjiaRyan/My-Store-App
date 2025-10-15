import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ryan_store_app/provider/cart_provider.dart';
import 'package:ryan_store_app/views/screens/main_screen.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _checkoutScreenState createState() => _checkoutScreenState();
}

class _checkoutScreenState extends ConsumerState<CheckoutScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String _selectedPaymentMethod = 'stripe';
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: cartProviderData.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  final cartItem = cartProviderData.values.toList()[index];
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      width: 336,
                      height: 91,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffeff0f2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 6,
                            top: 6,
                            child: SizedBox(
                              width: 311,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 78,
                                    height: 78,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: Color(0xffbcc5ff),
                                    ),
                                    child: Image.network(
                                      cartItem.imageUrl[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 11),
                                  Expanded(
                                    child: Container(
                                      height: 78,
                                      alignment: Alignment(0, -0.51),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                cartItem.productName,
                                                style: GoogleFonts.getFont(
                                                  'Lato',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                cartItem.categoryName,
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    cartItem.discount.toStringAsFixed(2),
                                    style: GoogleFonts.getFont(
                                      'Lato',
                                      fontSize: 14,
                                      color: Colors.pinkAccent.shade700,
                                      height: 1.3,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: Text('Stripe'),
              value: 'stripe',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Cash on Delivery'),
              value: 'cashOnDelivery',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () async {
            if (_selectedPaymentMethod == 'stripe') {
              //pay with stripe
            } else {
              setState(() {
                isLoading = true;
              });
              for (var item
                  in ref.read(cartProvider.notifier).getCartItem.values) {
                DocumentSnapshot userDoc =
                    await _firestore
                        .collection('buyers')
                        .doc(_auth.currentUser!.uid)
                        .get();
                CollectionReference orderRefer = _firestore.collection(
                  'orders',
                );
                final orderId = Uuid().v4();
                await orderRefer
                    .doc(orderId)
                    .set({
                      'orderId': orderId,
                      'productName': item.productName,
                      'productId': item.productId,
                      'size': item.productSize,
                      'quantity': item.quantity,
                      'price': item.quantity * item.productPrice,
                      'category': item.categoryName,
                      'productImage': item.imageUrl[0],
                      'state':
                          (userDoc.data() as Map<String, dynamic>)['state'],
                      'email':
                          (userDoc.data() as Map<String, dynamic>)['email'],
                      'locality':
                          (userDoc.data() as Map<String, dynamic>)['locality'],
                      'fullName':
                          (userDoc.data() as Map<String, dynamic>)['fullName'],
                      'buyerId': _auth.currentUser!.uid,
                      'deliveredCount': 0,
                      'delivered': false,
                      'processing': true,
                    })
                    .whenComplete(() {
                      cartProviderData.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MainScreen();
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.grey,
                          content: Text('order have been placed'),
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    });
              }
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff1532e7),
            ),
            child: Center(
              child:
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'PLACE ORDER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          height: 1.4,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
