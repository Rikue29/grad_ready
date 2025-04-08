import 'package:flutter/material.dart';
import 'homepage.dart'; // Import your homepage.dart file
import 'profile_page.dart'; // Import your profile page
import 'settings_page.dart'; // Import your settings page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: removes debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(), // ✅ Loads your homepage.dart
    );
  }
}
