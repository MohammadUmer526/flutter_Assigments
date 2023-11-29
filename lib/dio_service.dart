import 'package:dio/dio.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class DioService {
  final Dio _dio = Dio();
  Future<Map<String, dynamic>> fetchData(BuildContext context) async {
    try {
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
      _showSuccessMessage(context, 'Dio Request Successful');
      return response.data;
    } catch (e) {
      _showErrorMessage(context, 'Dio Request Failed');
      throw Exception('Failed to load data');
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    )..show(context); // Pass the context here
  }

  void _showErrorMessage(BuildContext context, String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    )..show(context); // Pass the context here
  }
}
