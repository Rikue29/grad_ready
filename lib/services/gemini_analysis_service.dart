import 'package:google_generative_ai/google_generative_ai.dart';
import 'env_config_service.dart';
import 'dart:convert';

class GeminiAnalysisService {
  late GenerativeModel _model;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('Initializing Gemini AI...');
      final apiKey = EnvConfigService.geminiApiKey;

      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );
      _model = model;
      _isInitialized = true;
      print('Gemini AI model initialized successfully');
    } catch (e) {
      print('Error initializing Gemini AI: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> analyzeSpeech(String transcript) async {
    if (!_isInitialized) {
      throw Exception('Gemini AI service not initialized');
    }

    try {
      print('Analyzing speech content...');
      final prompt = '''
Analyze this presentation transcript and provide detailed feedback in JSON format:

Transcript:
$transcript

Please analyze for:
1. Clarity and coherence
2. Use of filler words (um, uh, like, etc.)
3. Pacing (based on word count and structure)
4. Key points identified
5. Areas for improvement
6. Overall confidence score (0-100)

Respond in this exact JSON format:
{
  "clarity_score": <0-100>,
  "filler_words": {
    "count": <number>,
    "words": ["word1", "word2", ...],
    "improvement_suggestion": "suggestion"
  },
  "pacing": {
    "words_per_minute": <estimated>,
    "assessment": "too fast/good/too slow",
    "suggestion": "suggestion"
  },
  "key_points": [
    "point1",
    "point2",
    ...
  ],
  "improvements": [
    "suggestion1",
    "suggestion2",
    ...
  ],
  "confidence_score": <0-100>,
  "overall_feedback": "summary"
}
''';

      final response = await _model.generateContent([
        Content.text(prompt),
      ]);
      final content = response.text;

      if (content == null) {
        throw Exception('No analysis generated');
      }

      // Clean up the response by removing markdown code block markers
      String cleanedContent = content;
      if (cleanedContent.startsWith('```json')) {
        cleanedContent = cleanedContent.substring(7);
      }
      if (cleanedContent.endsWith('```')) {
        cleanedContent = cleanedContent.substring(0, cleanedContent.length - 3);
      }
      cleanedContent = cleanedContent.trim();

      // Parse the JSON response
      final analysis = json.decode(cleanedContent);
      print('Analysis completed successfully');
      return analysis;
    } catch (e) {
      print('Speech analysis error: $e');
      throw Exception('Failed to analyze speech: $e');
    }
  }

  Future<bool> testConnection() async {
    if (!_isInitialized) {
      throw Exception('Gemini AI service not initialized');
    }

    try {
      print('Testing Gemini AI connection...');
      final response = await _model.generateContent([
        Content.text('Hello, are you working?'),
      ]);
      return response.text != null;
    } catch (e) {
      print('Gemini AI connection test failed: $e');
      throw Exception('Failed to test Gemini AI connection: $e');
    }
  }
}
