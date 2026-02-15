import 'package:flutter/material.dart';

import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedStock = "AAPL";
  final List<String> stocks = ["AAPL", "TSLA", "MSFT", "GOOGL", "AMZN"];

  // Controllers for feature input
  final Map<String, TextEditingController> featureControllers = {
    "Adj Close": TextEditingController(),
    "Return": TextEditingController(),
    "MA5": TextEditingController(),
    "MA10": TextEditingController(),
    "Volatility": TextEditingController(),
    "Momentum": TextEditingController(),
    "Volume_Change": TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Predictor 📈"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Stock & Enter Features",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            /// Stock Dropdown
            DropdownButtonFormField(
              dropdownColor: const Color(0xFF1E293B),
              initialValue: selectedStock,
              items: stocks
                  .map(
                    (stock) =>
                        DropdownMenuItem(value: stock, child: Text(stock)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStock = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                labelText: "Select Stock",
              ),
            ),

            const SizedBox(height: 20),

            /// Feature Inputs
            Column(
              children: featureControllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    controller: entry.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: entry.key,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// Predict Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _predictStock,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Predict Now 🚀",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var c in featureControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _predictStock() {
    // Collect feature values
    final Map<String, dynamic> features = {};
    featureControllers.forEach((key, controller) {
      features[key] = double.tryParse(controller.text) ?? 0.0;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultScreen(symbol: selectedStock, features: features),
      ),
    );
  }
}
