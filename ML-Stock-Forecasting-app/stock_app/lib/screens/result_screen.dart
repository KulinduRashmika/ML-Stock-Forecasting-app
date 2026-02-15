import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ResultScreen extends StatefulWidget {
  final String symbol;
  final Map<String, dynamic>? features;

  const ResultScreen({super.key, required this.symbol, this.features});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic>? result;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.symbol} Prediction")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : result == null
            ? const Text(
                "Error getting prediction",
                style: TextStyle(fontSize: 18),
              )
            : Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      result!["direction"] == "UP"
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color: result!["direction"] == "UP"
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${widget.symbol} Prediction",
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      result!["direction"],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: result!["direction"] == "UP"
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Current: ${result!["current_price"].toStringAsFixed(2)}",
                    ),
                    Text(
                      "Predicted: ${result!["predicted_price"].toStringAsFixed(2)}",
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void fetchPrediction() async {
    final data = await ApiService.getPrediction(
      widget.symbol,
      features: widget.features,
    );
    setState(() {
      result = data.isEmpty ? null : data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPrediction();
  }
}
