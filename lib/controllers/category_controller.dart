import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ryan_store_app/models/category_models.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _fetchCategories();
  }

  void _fetchCategories() {
    _firestore.collection('categories').snapshots().listen((
      QuerySnapshot querySnapshots,
    ) {
      categories.assignAll(
        querySnapshots.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return CategoryModel(
            categoryName: data['categoryName'],
            categoryImage: data['categoryImage'],
          );
        }).toList(),
      );
    });
  }
}
