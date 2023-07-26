import 'package:flutter/material.dart';
import 'package:flutter_backblaze/screens/image_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appwrite + Backblaze demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageScreen(),
    );
  }
}
