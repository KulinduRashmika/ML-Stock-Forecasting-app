import 'package:fl_chart/fl_chart.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Stock Predictor 📈",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "AI-powered stock movement prediction",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// Chart Section
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: const [
                          FlSpot(0, 3),
                          FlSpot(1, 4),
                          FlSpot(2, 2),
                          FlSpot(3, 5),
                          FlSpot(4, 3.5),
                          FlSpot(5, 4.8),
                        ],
                        color: Colors.greenAccent,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Stock Dropdown
              DropdownButtonFormField(
                dropdownColor: const Color(0xFF1E293B),
                initialValue: selectedStock,
                items: stocks
                    .map((stock) => DropdownMenuItem(
                          value: stock,
                          child: Text(stock),
                        ))
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
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Select Stock",
                ),
              ),

              const Spacer(),

              /// Premium Predict Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _predictStock,
                  child: const Text(
                    "Predict Now 🚀",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _predictStock() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(symbol: selectedStock),
      ),
    );
  }
}
