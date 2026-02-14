import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String symbol;

  const ResultScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Result"),
      ),
      body: Center(
        child: Text(
          "Prediction for $symbol\n\nUP 📈",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
