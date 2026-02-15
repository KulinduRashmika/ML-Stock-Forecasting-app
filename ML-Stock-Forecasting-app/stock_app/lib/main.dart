import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const StockPredictorApp());
}

class StockPredictorApp extends StatelessWidget {
  const StockPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Predictor',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F111A),
        primaryColor: Colors.greenAccent,
      ),
      home: const HomeScreen(),
    );
  }
}
