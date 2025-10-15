import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String state;
  late String city;
  late String locality;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.96),
        title: Text(
          'Delivery',
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'where will your order\n be shipped',
                    style: GoogleFonts.lato(fontSize: 18, letterSpacing: 2),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      state = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(labelText: 'State'),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    onChanged: (value) {
                      city = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(labelText: 'City'),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    onChanged: (value) {
                      locality = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(labelText: 'Locality'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              //update user locality, city, state, pinCode
              await _firestore
                  .collection('buyers')
                  .doc(_auth.currentUser!.uid)
                  .update({'state': state, 'city': city, 'locality': locality});
            } else {
              //we can show snackBar
            }
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xff1532e7),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Text(
                'Add Address',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
