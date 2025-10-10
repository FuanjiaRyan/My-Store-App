import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ryan_store_app/controllers/category_controller.dart';
import 'package:ryan_store_app/views/screens/authentication_screens/login_screen.dart';
import 'package:ryan_store_app/views/screens/authentication_screens/register_screen.dart';
import 'dart:io';

import 'package:ryan_store_app/views/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      if (Platform.isAndroid) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyAi5eir7GR2iyhAaWLgK8fXyqFg4acK_-c',
            appId: '1:251688077288:android:9198cfd4e46a14c770465d',
            messagingSenderId: '251688077288',
            projectId: 'upheld-caldron-465808-c2',
            storageBucket: 'gs://upheld-caldron-465808-c2.firebasestorage.app',
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
    }
  } catch (e) {
    // If there's an error, try to delete and reinitialize
    try {
      await Firebase.app().delete();
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAi5eir7GR2iyhAaWLgK8fXyqFg4acK_-c',
          appId: '1:251688077288:android:9198cfd4e46a14c770465d',
          messagingSenderId: '251688077288',
          projectId: 'upheld-caldron-465808-c2',
          storageBucket: 'gs://upheld-caldron-465808-c2.firebasestorage.app',
        ),
      );
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put<CategoryController>(CategoryController());
      }),
    );
  }
}
