import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 111, 253),
          brightness: Brightness.light,
          // surface: Color.fromARGB(255, 0, 136, 255),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
