import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class EnvConfigService {
  static Future<void> initialize() async {
    await dotenv.load();
  }

  static String get geminiApiKey {
    return dotenv.env['GEMINI_API_KEY'] ?? '';
  }

  static Future<Map<String, dynamic>> get gcpCredentials async {
    try {
      // For a file in the assets folder
      final String jsonString =
          await rootBundle.loadString('assets/service-account.json');
      return json.decode(jsonString);
    } catch (e) {
      throw Exception('Failed to load service-account.json: $e');
    }
  }
}
