import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ryan_store_app/provider/cart_provider.dart';
import 'package:ryan_store_app/views/screens/inner_screens/shipping_address_screen.dart';
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

  //get current user info
  String state = '';
  String city = '';
  String locality = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  //get current user details
  void getUserData() {
    Stream<DocumentSnapshot> userDataStream =
        _firestore.collection('buyers').doc(_auth.currentUser!.uid).snapshots();

    //listen to the stream and update the data
    userDataStream.listen((DocumentSnapshot userData) {
      if (userData.exists) {
        setState(() {
          state = userData.get('state');
          city = userData.get('city');
          locality = userData.get('locality');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShippingAddressScreen();
                      },
                    ),
                  );
                },
                child: SizedBox(
                  width: 335,
                  height: 74,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 335,
                          height: 74,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xffeff0f2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 70,
                        top: 17,
                        child: SizedBox(
                          width: 215,
                          height: 41,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: -1,
                                top: -1,
                                child: SizedBox(
                                  width: 219,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Add Address',
                                          style: GoogleFonts.getFont(
                                            'Lato',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Enter City',
                                          style: GoogleFonts.getFont(
                                            'Lato',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3,
                                            color: Color(0xff7f808c),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: SizedBox.square(
                          dimension: 42,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 43,
                                  height: 43,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Color(0xfffbf7f5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                        left: 11,
                                        top: 11,
                                        child: Image.asset(
                                          'assets/icons/location1.png',
                                          color: Colors.blueAccent.shade700,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 305,
                        top: 25,
                        child: Image.asset(
                          'assets/icons/edit.png',
                          width: 24,
                          height: 24,
                          color: Colors.blueAccent.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Your item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
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
      ),
      bottomSheet:
          state == ''
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ShippingAddressScreen();
                        },
                      ),
                    );
                  },
                  child: Text('Add Address'),
                ),
              )
              : Padding(
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
                          in ref
                              .read(cartProvider.notifier)
                              .getCartItem
                              .values) {
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
                                  (userDoc.data()
                                      as Map<String, dynamic>)['state'],
                              'email':
                                  (userDoc.data()
                                      as Map<String, dynamic>)['email'],
                              'locality':
                                  (userDoc.data()
                                      as Map<String, dynamic>)['locality'],
                              'fullName':
                                  (userDoc.data()
                                      as Map<String, dynamic>)['fullName'],
                              'buyerId': _auth.currentUser!.uid,
                              'deliveredCount': 0,
                              'delivered': false,
                              'processing': true,
                          'city': (userDoc.data()
                          as Map<String, dynamic>)['city'],
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
