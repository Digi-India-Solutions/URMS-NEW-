import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SubmitService {
  static final Uri _endpoint = Uri.parse('https://api.zaikanuts.shop/api/send-record');

  /// Submit data with address and other images.
  static Future<bool> submitData({
    required Map<String, dynamic> data,
    required List<File> addressImages,
    required List<File> images,
  }) async {
    try {
      final request = http.MultipartRequest('POST', _endpoint);

      _addFormFields(request, data);
      await _addImageFiles(request, addressImages, 'addressImage');
      await _addImageFiles(request, images, 'images');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Submit response: $responseBody');

      return response.statusCode == 200;
    } catch (e) {
      print('Error during submission: $e');
      return false;
    }
  }

  /// Adds form fields to the request
  static void _addFormFields(http.MultipartRequest request, Map<String, dynamic> data) {
    for (final entry in data.entries) {
      if (entry.value != null) {
        request.fields[entry.key] = entry.value.toString();
      }
    }
  }

  /// Adds image files to the request under the specified field name.
  static Future<void> _addImageFiles(http.MultipartRequest request, List<File> files, String fieldName) async {
    for (final file in files) {
      final mimeType = _getMimeType(file.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          contentType: MediaType('image', mimeType),
        ),
      );
    }
  }

  /// Returns MIME type based on file extension
  static String _getMimeType(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    return ext == 'png' ? 'png' : 'jpeg';
  }
}
