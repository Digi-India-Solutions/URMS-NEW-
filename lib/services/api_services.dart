// // lib/services/api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../constants/api_constants.dart';
//
// class ApiService {
//   // ----------------- AUTH -----------------
//   static Future<http.Response> login(String email, String password) {
//     return http.post(
//       Uri.parse(ApiConstants.login),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}),
//     );
//   }
//
//   // ----------------- FIELD EXECUTIVE -----------------
//   static Future<http.Response> getAllFields() async {
//     return await http.get(Uri.parse(ApiConstants.getAllFields));
//   }
//
//   static Future<http.Response> getFieldById(String id) async {
//     return await http.get(Uri.parse('${ApiConstants.getFieldById}/$id'));
//   }
//
//   static Future<http.Response> createField(Map<String, dynamic> fieldData) async {
//     return await http.post(
//       Uri.parse(ApiConstants.createField),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(fieldData),
//     );
//   }
//
//   // ----------------- TASK -----------------
//   static Future<http.Response> getAllTasks() async {
//     return await http.get(Uri.parse(ApiConstants.getAllTasks));
//   }
//
//   static Future<http.Response> createTask(Map<String, dynamic> taskData) async {
//     return await http.post(
//       Uri.parse(ApiConstants.createTask),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(taskData),
//     );
//   }
//
//   static Future<http.Response> updateTask(String id, Map<String, dynamic> taskData) async {
//     return await http.put(
//       Uri.parse('${ApiConstants.updateTask}/$id'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(taskData),
//     );
//   }
//
//   static Future<http.Response> deleteTask(String id) async {
//     return await http.delete(Uri.parse('${ApiConstants.deleteTask}/$id'));
//   }
//
//   // ----------------- OFFICE -----------------
//   static Future<http.Response> getAllOffices() async {
//     return await http.get(Uri.parse(ApiConstants.getAllOffices));
//   }
//
//   static Future<http.Response> createOffice(Map<String, dynamic> officeData) async {
//     return await http.post(
//       Uri.parse(ApiConstants.createOffice),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(officeData),
//     );
//   }
//
//   static Future<http.Response> deleteOffice(String id) async {
//     return await http.delete(Uri.parse('${ApiConstants.deleteOffice}/$id'));
//   }
// }



// lib/services/api_service.dart
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../constants/api_constants.dart';
//
// class ApiService {
//   // ----------------- AUTH -----------------
//   static Future<http.Response> login(String email, String password) {
//     return http.post(
//       Uri.parse(ApiConstants.login),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}),
//     );
//   }
//
//   // ----------------- FIELD EXECUTIVE -----------------
//   static Future<http.Response> getAllFields() async {
//     return await http.get(Uri.parse(ApiConstants.getAllFields));
//   }
//
//   static Future<http.Response> getFieldById(String id) async {
//     return await http.get(Uri.parse('${ApiConstants.getFieldById}/$id'));
//   }
//
//   static Future<http.Response> createField(Map<String, dynamic> fieldData) async {
//     return await http.post(
//       Uri.parse(ApiConstants.createField),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(fieldData),
//     );
//   }
//
//   // ----------------- TASK -----------------
//   static Future<http.Response> getAllTasks() async {
//     return await http.get(Uri.parse(ApiConstants.getAllTasks));
//   }
//
//   static Future<http.Response> createTask(Map<String, dynamic> taskData) async {
//     return await http.post(
//       Uri.parse(ApiConstants.createTask),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(taskData),
//     );
//   }
//
//   static Future<http.Response> updateTask(String id, Map<String, dynamic> taskData) async {
//     return await http.put(
//       Uri.parse('${ApiConstants.updateTask}/$id'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(taskData),
//     );
//   }
//
//   static Future<http.Response> deleteTask(String id) async {
//     return await http.delete(Uri.parse('${ApiConstants.deleteTask}/$id'));
//   }
//
//   // ----------------- OFFICE -----------------
//   static Future<http.Response> getAllOffices() async {
//     return await http.get(Uri.parse(ApiConstants.getAllOffices));
//   }
//
//   static Future<http.Response> createOffice(Map<String, dynamic> officeData) async {
//     return await http.post(
//       Uri.parse(ApiConstants.createOffice),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(officeData),
//     );
//   }
//
//   static Future<http.Response> deleteOffice(String id) async {
//     return await http.delete(Uri.parse('${ApiConstants.deleteOffice}/$id'));
//   }
//
//   // ----------------- OFFLINE RECORD SYNC -----------------
//   static Future<bool> sendOfflineRecord(Map<String, dynamic> formData) async {
//     try {
//       final uri = Uri.parse('https://api.zaikanuts.shop/api/send-record');
//       final request = http.MultipartRequest('POST', uri);
//
//       // Add standard string fields
//       formData.forEach((key, value) {
//         if (value is String) {
//           request.fields[key] = value;
//         }
//       });
//
//       // Add addressImage[] (1st and 2nd image)
//       if (formData['addressImage'] != null && formData['addressImage'] is List) {
//         List<dynamic> addressImages = formData['addressImage'];
//         for (var imagePath in addressImages) {
//           if (imagePath is String && File(imagePath).existsSync()) {
//             request.files.add(await http.MultipartFile.fromPath('addressImage[]', imagePath));
//           }
//         }
//       }
//
//       // Add images[] (3rd to 6th image)
//       if (formData['images'] != null && formData['images'] is List) {
//         List<dynamic> images = formData['images'];
//         for (var imagePath in images) {
//           if (imagePath is String && File(imagePath).existsSync()) {
//             request.files.add(await http.MultipartFile.fromPath('images[]', imagePath));
//           }
//         }
//       }
//
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         return responseData['success'] == true;
//       } else {
//         print('Sync failed with status: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('Error sending offline record: $e');
//       return false;
//     }
//   }
// }
//
//
//




import 'dart:convert';
import 'dart:io';
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

  // ----------------- OFFLINE RECORD SYNC -----------------
  /// Submits offline saved request data via multipart form.
  /// Returns true if submission is successful, false otherwise.
  static Future<bool> submitOfflineRequest(Map<String, dynamic> offlineRequest) async {
    try {
      final uri = Uri.parse('https://api.zaikanuts.shop/api/send-record');
      final request = http.MultipartRequest('POST', uri);

      // Add standard string fields to the multipart request
      offlineRequest.forEach((key, value) {
        if (value is String) {
          request.fields[key] = value;
        }
      });

      // Add addressImage[] files if present
      if (offlineRequest['addressImage'] != null && offlineRequest['addressImage'] is List) {
        List<dynamic> addressImages = offlineRequest['addressImage'];
        for (var imagePath in addressImages) {
          if (imagePath is String && File(imagePath).existsSync()) {
            request.files.add(await http.MultipartFile.fromPath('addressImage[]', imagePath));
          }
        }
      }

      // Add images[] files if present
      if (offlineRequest['images'] != null && offlineRequest['images'] is List) {
        List<dynamic> images = offlineRequest['images'];
        for (var imagePath in images) {
          if (imagePath is String && File(imagePath).existsSync()) {
            request.files.add(await http.MultipartFile.fromPath('images[]', imagePath));
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['success'] == true;
      } else {
        print('Submit offline request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error submitting offline request: $e');
      return false;
    }
  }
}
