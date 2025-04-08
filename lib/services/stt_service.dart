import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/speech/v1.dart' as speech;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class STTService {
  static Future<String?> transcribeAudio(File audioFile) async {
    try {
      // Load the service account credentials
      final jsonCredentials =
      await rootBundle.loadString('assets/keys/service-speech-to-text.json');
      final credentials =
      ServiceAccountCredentials.fromJson(json.decode(jsonCredentials));

      // Create an authenticated HTTP client
      final client = await clientViaServiceAccount(
        credentials,
        [speech.SpeechApi.cloudPlatformScope],
      );

      final speechApi = speech.SpeechApi(client);

      final audioBytes = audioFile.readAsBytesSync();
      final audioBase64 = base64Encode(audioBytes);

      final config = speech.RecognitionConfig(
        encoding: 'FLAC',
        sampleRateHertz: 16000,
        languageCode: 'en-US',
      );

      final audio = speech.RecognitionAudio(content: audioBase64);

      final request = speech.RecognizeRequest(
        config: config,
        audio: audio,
      );

      final response = await speechApi.speech.recognize(request);
      client.close();

      if (response.results != null && response.results!.isNotEmpty) {
        return response.results!
            .map((r) => r.alternatives!.first.transcript)
            .join(' ');
      }

      return null;
    } catch (e) {
      print('[STT ERROR]: $e');
      return null;
    }
  }
}