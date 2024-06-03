import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioApiCall {
  final String baseUrl;

  DioApiCall() : baseUrl = dotenv.env['BACKEND_URL'] ?? '';
  // https:// .... /api/v1

  Dio dio = Dio();

  Future<Map<String, dynamic>> get(String url) async {
    try {
      Response response = await dio.get(baseUrl + url);
      return response.data;
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<List<dynamic>> getDynamic(String url) async {
    try {
      Response response = await dio.get(baseUrl + url);
      return response.data
          as List<dynamic>; // Ensure the response is a List<dynamic>
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> post(
      String url, Map<String, dynamic> data) async {
    try {
      Response response = await dio.post((baseUrl + url), data: data);
      return response.data;
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> put(
      String url, Map<String, dynamic> data) async {
    try {
      Response response = await dio.put((baseUrl + url), data: data);
      return response.data;
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> delete(String url) async {
    try {
      Response response = await dio.delete((baseUrl + url));
      return response.data;
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteForData(
      String url, Map<String, dynamic> data) async {
    try {
      Response response = await dio.delete((baseUrl + url), data: data);
      return response.data;
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> multipartReq(
      String url, FormData formData) async {
    try {
      Response response = await dio.post((baseUrl + url), data: formData);
      return response.data;
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> ImageReq(
      String url, Map<String, dynamic> data) async {
    try {
      var formData = FormData.fromMap(data);
      Response response = await dio.patch((baseUrl + url), data: formData);
      return response.data;
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }
  Future<Map<String, dynamic>> modify(
      String url, Map<String, dynamic> data) async {
    try {
      Response response = await dio.patch((baseUrl + url), data: data);
      return response.data;
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }
  
}
