// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiService {
  // ----------------- AUTH -----------------
  static Future<http.Response> login(String email, String password) {
    return http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  // ----------------- FIELD EXECUTIVE -----------------
  static Future<http.Response> getAllFields() async {
    return await http.get(Uri.parse(ApiConstants.getAllFields));
  }

  static Future<http.Response> getFieldById(String id) async {
    return await http.get(Uri.parse('${ApiConstants.getFieldById}/$id'));
  }

  static Future<http.Response> createField(Map<String, dynamic> fieldData) async {
    return await http.post(
      Uri.parse(ApiConstants.createField),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(fieldData),
    );
  }

  // ----------------- TASK -----------------
  static Future<http.Response> getAllTasks() async {
    return await http.get(Uri.parse(ApiConstants.getAllTasks));
  }

  static Future<http.Response> createTask(Map<String, dynamic> taskData) async {
    return await http.post(
      Uri.parse(ApiConstants.createTask),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );
  }

  static Future<http.Response> updateTask(String id, Map<String, dynamic> taskData) async {
    return await http.put(
      Uri.parse('${ApiConstants.updateTask}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );
  }

  static Future<http.Response> deleteTask(String id) async {
    return await http.delete(Uri.parse('${ApiConstants.deleteTask}/$id'));
  }

  // ----------------- OFFICE -----------------
  static Future<http.Response> getAllOffices() async {
    return await http.get(Uri.parse(ApiConstants.getAllOffices));
  }

  static Future<http.Response> createOffice(Map<String, dynamic> officeData) async {
    return await http.post(
      Uri.parse(ApiConstants.createOffice),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(officeData),
    );
  }

  static Future<http.Response> deleteOffice(String id) async {
    return await http.delete(Uri.parse('${ApiConstants.deleteOffice}/$id'));
  }
}


