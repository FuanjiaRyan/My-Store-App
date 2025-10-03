import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ryan_store_app/views/screens/authentication_screens/login_screen.dart';
import 'dart:io';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen(),
    );
  }
}
