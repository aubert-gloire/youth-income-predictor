import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Set your deployed API base URL here for production
  static const String _baseUrl = 'https://youth-income-predictor.onrender.com'; // Public Render API URL for production

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
