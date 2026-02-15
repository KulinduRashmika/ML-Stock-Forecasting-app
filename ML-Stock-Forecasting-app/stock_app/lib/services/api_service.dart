import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000";

  static Future<Map<String, dynamic>> getPrediction(
    String symbol, {
    Map<String, dynamic>? features,
  }) async {
    final Map<String, dynamic> bodyFeatures =
        features ??
        {
          "Adj Close": 100.0,
          "Return": 0.01,
          "MA5": 98.0,
          "MA10": 95.0,
          "Volatility": 1.5,
          "Momentum": 2.0,
          "Volume_Change": 0.03,
        };

    final response = await http.post(
      Uri.parse("$baseUrl/predict"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"symbol": symbol, "features": bodyFeatures}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded is Map<String, dynamic>
          ? decoded
          : Map<String, dynamic>.from(decoded);
    } else {
      throw Exception("Failed to fetch prediction");
    }
  }
}
