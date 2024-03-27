import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class ApiCall {
  final String baseUrl;

  ApiCall() : baseUrl = dotenv.env['BACKEND_URL'] ?? '';

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    var url = '$baseUrl$endpoint';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print('Caught error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    var url = '$baseUrl$endpoint';
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      print('Caught error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> multipartReq(
      String endpoint, Map<String, dynamic> body,
      {required XFile? imageFile}) async {
    var url = '$baseUrl$endpoint';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // 일반 파라미터 추가
    body.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // 파일 Path 추가
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'clubImage', // parameter name for the file
        imageFile.path,
      ));
    } else {
      return {"error": "이미지 파일이 없습니다."};
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        return jsonDecode(respStr);
      } else {
        print('Upload failed with status code: ${response.statusCode}.');
        return {};
      }
    } catch (e) {
      print('Caught error: $e');
      return {};
    }
  }
}
