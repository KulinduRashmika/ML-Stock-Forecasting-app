import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000"; // emulator localhost

  static Future<Map<String, dynamic>> predictStock(String symbol) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"symbol": symbol}),
    );

    return jsonDecode(response.body);
  }
}
