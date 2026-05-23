import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const StampLetterApp());
}

class StampLetterApp extends StatelessWidget {
  const StampLetterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StampLetter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFC0392B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC0392B),
          primary: const Color(0xFFC0392B),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
