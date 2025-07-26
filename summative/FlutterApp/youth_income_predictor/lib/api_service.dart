import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Set your deployed API base URL here for production
  static const String _baseUrl = 'http://192.168.1.70:8000'; // Local network IP for device testing

  static Future<Map<String, dynamic>> predictIncome(Map<String, dynamic> input) async {
    final url = Uri.parse('$_baseUrl/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(input),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error:  {response.body}');
    }
  }
}
