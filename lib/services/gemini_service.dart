import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final _apiKey = dotenv.env['GEMINI_API_KEY'];
  static final _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  static Future<String?> getInterviewQuestion(String jobRole) async {
    final prompt =
        "Generate 1 realistic and professional interview question for the role of $jobRole. Return only the question text.";
    return await _sendPrompt(prompt);
  }

  static Future<String?> getImprovementFeedback(String transcript) async {
    final prompt =
        "You are an AI interview coach. Analyze the following interview response and suggest improvements in tone, clarity, and professionalism:\n\n\"$transcript\"\n\nProvide the feedback in a paragraph.";
    return await _sendPrompt(prompt);
  }

  static Future<String?> _sendPrompt(String prompt) async {
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('[GEMINI STATUS]: ${response.statusCode}');
      print('[GEMINI RAW]: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('[GEMINI ERROR]: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('[GEMINI EXCEPTION]: $e');
      return null;
    }
  }
}
