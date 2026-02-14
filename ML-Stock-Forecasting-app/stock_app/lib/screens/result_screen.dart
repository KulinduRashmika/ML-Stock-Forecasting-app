import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String symbol;

  const ResultScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Icon(
                Icons.trending_up,
                color: Colors.greenAccent,
                size: 60,
              ),

              const SizedBox(height: 20),

              Text(
                "$symbol Prediction",
                style: const TextStyle(fontSize: 22),
              ),

              const SizedBox(height: 15),

              const Text(
                "UP 📈",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Confidence: 62%",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
