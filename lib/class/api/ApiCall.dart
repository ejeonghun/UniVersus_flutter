import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiCall {
  final String baseUrl;

  ApiCall() : baseUrl = dotenv.env['BACKEND_URL'] ?? ''; // 기본값을 추가했습니다.

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    var url = '$baseUrl$endpoint';
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> get(String endpoint) async { // body 매개변수를 제거했습니다.
    var url = '$baseUrl$endpoint';
    var response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }
}