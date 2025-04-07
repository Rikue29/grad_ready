import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class EnvConfigService {
  static Future<void> initialize() async {
    await dotenv.load();
  }

  static String get geminiApiKey {
    return dotenv.env['GEMINI_API_KEY'] ?? '';
  }

  static Map<String, dynamic> get gcpCredentials {
    final credentialsJson = dotenv.env['GCP_SERVICE_ACCOUNT'] ?? '{}';
    return json.decode(credentialsJson);
  }
}
