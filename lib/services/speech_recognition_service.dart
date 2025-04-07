import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'audio_stream_service.dart';

class SpeechRecognitionService {
  bool _isListening = false;
  double _confidence = 1.0;
  Function(String)? _onTranscript;
  Function(double)? _onConfidenceUpdate;
  StreamSubscription? _streamSubscription;
  SpeechToText? _speechToText;

  bool get isListening => _isListening;
  double get confidence => _confidence;

  Future<bool> initialize() async {
    try {
      // Check if we already have permission
      var status = await Permission.microphone.status;
      if (status.isDenied) {
        // Request permission
        status = await Permission.microphone.request();
        if (status.isDenied) {
          return false;
        }
      }

      if (status.isPermanentlyDenied) {
        return false;
      }

      // Load service account credentials
      final serviceAccount = ServiceAccount.fromString(
        await rootBundle.loadString('assets/service-account.json'),
      );

      // Initialize the speech to text service
      _speechToText = SpeechToText.viaServiceAccount(serviceAccount);
      return true;
    } catch (e) {
      print('Error initializing speech service: $e');
      return false;
    }
  }

  Future<void> startListening({
    required Function(String) onTranscript,
    Function(double)? onConfidenceUpdate,
  }) async {
    if (_isListening) return;

    _onTranscript = onTranscript;
    _onConfidenceUpdate = onConfidenceUpdate;

    try {
      _isListening = true;

      // Configure recognition
      final config = RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        languageCode: 'en-US',
      );

      // Start streaming recognition
      final streamingConfig = StreamingRecognitionConfig(
        config: config,
        interimResults: true,
      );

      // Get the audio stream from the microphone
      final audioStream = await AudioStreamService.getAudioStream();
      final responseStream = _speechToText!.streamingRecognize(
        streamingConfig,
        audioStream,
      );

      _streamSubscription = responseStream.listen(
        (data) {
          if (data.results.isNotEmpty) {
            final result = data.results.first;
            final transcript = result.alternatives.first.transcript;
            _onTranscript?.call(transcript);

            // Update confidence if available
            if (result.alternatives.first.confidence > 0) {
              _confidence = result.alternatives.first.confidence;
              _onConfidenceUpdate?.call(_confidence);
            }
          }
        },
        onError: (error) {
          print('Error during recognition: $error');
          stopListening();
        },
      );
    } catch (e) {
      print('Error starting recording: $e');
      _isListening = false;
      throw Exception('Error starting recording: $e');
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await AudioStreamService.stopAudioStream();
      _streamSubscription?.cancel();
      _isListening = false;
    } catch (e) {
      print('Error stopping recording: $e');
      throw Exception('Error stopping recording: $e');
    }
  }

  void dispose() {
    _streamSubscription?.cancel();
    if (_isListening) {
      stopListening();
    }
  }
}
