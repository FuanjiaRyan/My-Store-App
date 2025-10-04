import 'package:flutter/material.dart';
import 'package:ryan_store_app/controllers/banner_controller.dart';

class BannerWidget extends StatefulWidget {
 const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final BannerController _bannerController = BannerController();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final List _bannerImage = [];
  //
  // getBanners() {
  //   return _firestore
  //       .collection('banners')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //         querySnapshot.docs.forEach((doc) {
  //           setState(() {
  //             _bannerImage.add(doc['image']);
  //           });
  //         });
  //   });
  // }

  // @override
  // void initState() {
  //   getBanners();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(
          color: Color(0xfff7f7f7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(0,2),
            ),
          ],
        ),
        child: StreamBuilder<List<String>>(
            stream: _bannerController.getBannerUrls(),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent,),
                );
              } else if(snapshot.hasError) {
                return Icon(Icons.error);
              } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No Banner available', style: TextStyle(fontSize: 18, color: Colors.grey),),
                );
              } else {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Image.network(snapshot.data![index], fit: BoxFit.cover,);
                        },
                    )
                  ],
                );
              }
            },
        ),
      ),
    );
    // 
    // SizedBox(
    //   height: 140,
    //   width: MediaQuery.of(context).size.width,
    //   child: PageView.builder(
    //     itemCount: _bannerImage.length,
    //       itemBuilder: (context, index) {
    //         return Image.network(_bannerImage[index]);
    //       },
    //   ),
    // );
  }
}
