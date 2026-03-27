import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../models/scan_result.dart';

class ApiService {
  // Troque pela URL da sua API
  static const String baseUrl = 'https://reuse-backend-rylb.onrender.com';

  static Future<ScanResult> scanImage(XFile imageFile) async {
    final uri = Uri.parse('$baseUrl/scan');
    final request = http.MultipartRequest('POST', uri);

    final fileName = imageFile.name.isNotEmpty ? imageFile.name : 'upload.jpg';
    final lowerName = fileName.toLowerCase();

    String mimeSubType = 'jpeg';
    if (lowerName.endsWith('.png')) {
      mimeSubType = 'png';
    } else if (lowerName.endsWith('.jpg') || lowerName.endsWith('.jpeg')) {
      mimeSubType = 'jpeg';
    }

    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: fileName,
          contentType: MediaType('image', mimeSubType),
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: fileName,
          contentType: MediaType('image', mimeSubType),
        ),
      );
    }

    final streamedResponse =
        await request.send().timeout(const Duration(seconds: 30));

    final response = await http.Response.fromStream(streamedResponse);

    if (kDebugMode) {
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return ScanResult.fromJson(decoded);
    }

    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }
}