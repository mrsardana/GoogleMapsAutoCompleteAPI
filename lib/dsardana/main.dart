import 'package:dsardana_test/dsardana/store_location.dart';
import 'package:flutter/material.dart';

const String GOOGLE_API_KEY = "";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: const StoreLocation(),
      ),
    );
  }
}
