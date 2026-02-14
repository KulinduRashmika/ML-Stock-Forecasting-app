import 'package:flutter/material.dart';

import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Price Predictor"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Stock Symbol",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "e.g. AAPL",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictStock,
              child: const Text("Predict"),
            )
          ],
        ),
      ),
    );
  }

  void _predictStock() {
    String symbol = _controller.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(symbol: symbol),
      ),
    );
  }
}
