import 'package:firebase_app/screens/add_product_screen.dart';
import 'package:firebase_app/screens/products_screen.dart';
import 'package:firebase_app/views/add_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/addproduct'      : (BuildContext context) => AddProductScreen(),
      },
      debugShowCheckedModeBanner: false, 
      home: ListProducts()
    );
    
  }
}


