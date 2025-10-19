import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final TextEditingController _sizeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final List<String> _categoryList = [];

  //we will be uploading the values stored in this variables to the cloud firestore
  final List<String> _sizeList = [];
  String? selectedCategory;
  String? productName;
  double? productPrice;
  int? discount;
  int? quantity;
  String? description;
  bool _isEntered = false;
  //create an instance of the image picker to handle image selection
  final ImagePicker picker = ImagePicker();
  final List<String> _imagesUrls = [];

  //initialise an empty list to store the selected images
  List<File> images = [];

  //Define a function to choose image from the gallery
  chooseImage() async {
    //use the picker to select an image from gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    //check if no image was picked
    if (pickedFile == null) {
      print('no image picked');
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  //method to upload the selected images
  uploadImageToStorage() async {
    for (var image in images) {
      Reference ref = _firebaseStorage
          .ref()
          .child('productImages')
          .child(Uuid().v4());
      await ref.putFile(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          setState(() {
            _imagesUrls.add(value);
          });
        });
      });
    }
  }

  //Function to upload product to cloud
  uploadData() async {
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot vendorDoc =
        await _firestore
            .collection('vendors')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
    await uploadImageToStorage();
    if (_imagesUrls.isNotEmpty) {
      final productId = Uuid().v4();
      await _firestore
          .collection('products')
          .doc(productId)
          .set({
            'productId': productId,
            'productName': productName,
            'productPrice': productPrice,
            'productSize': _sizeList,
            'category': selectedCategory,
            'description': description,
            'discount': discount,
            'quantity': quantity,
            'productImages': _imagesUrls,
            'vendorId': FirebaseAuth.instance.currentUser!.uid,
            'vendorName':
                (vendorDoc.data() as Map<String, dynamic>)['fullName'],
            'rating': 0,
            'totalReviews': 0,
        'isPopular': false,
          })
          .whenComplete(() {
            setState(() {
              _isLoading = false;
              _formKey.currentState!.reset();
              _imagesUrls.clear();
              images.clear();
            });
          });
    }
  }

  //fetch categories from cloud firestore
  _getCategories() {
    return _firestore.collection('categories').get().then((
      QuerySnapshot querySnapshot,
    ) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      }
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: images.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                //if index is 0, display an icon button to add a new image
                return index == 0
                    ? Center(
                      child: IconButton(
                        onPressed: () {
                          chooseImage();
                        },
                        icon: Icon(Icons.add),
                      ),
                    )
                    : SizedBox(child: Image.file(images[index - 1]));
              },
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      productName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Product Name',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.isNotEmpty &&
                                double.tryParse(value) != null) {
                              productPrice = double.parse(value);
                            } else {
                              //handle the case where value is invalid or empty
                              productPrice = 0.0;
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter field';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Price',
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(child: buildDropDownField()),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty && int.tryParse(value) != null) {
                        discount = int.parse(value);
                      } else {
                        //handle the case where value is invalid or empty
                        discount = 0;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Discount',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty && int.tryParse(value) != null) {
                        quantity = int.parse(value);
                      } else {
                        //handle the case where value is invalid or empty
                        quantity = 1;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      description = value;
                    },
                    maxLength: 800,
                    maxLines: 4,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Description',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _sizeController,
                            onChanged: (value) {
                              setState(() {
                                _isEntered = true;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Add Size',
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      _isEntered == true
                          ? Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _sizeList.add(_sizeController.text);
                                  _sizeController.clear();
                                });
                              },
                              child: Text('Add'),
                            ),
                          )
                          : Text(''),
                    ],
                  ),
                  _sizeList.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _sizeList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _sizeList.removeAt(index);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.shade700,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _sizeList[index],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      : Text(''),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  uploadImageToStorage();
                  if (_formKey.currentState!.validate()) {
                    uploadData();
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              'Upload Product',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropDownField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Select category',
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          _categoryList.map((value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedCategory = value;
          });
        }
      },
    );
  }
}
