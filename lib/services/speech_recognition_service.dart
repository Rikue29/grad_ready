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
  String _completeTranscript = '';
  String _lastInterimResult = '';

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
    _completeTranscript = ''; // Reset the complete transcript when starting new session
    _lastInterimResult = '';

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

            // Handle the transcript based on whether it's final or interim
            if (result.isFinal) {
              // For final results, append to the complete transcript
              _completeTranscript += ' $transcript';
              _lastInterimResult = '';
            } else {
              // For interim results, store temporarily
              _lastInterimResult = transcript;
            }

            // Combine complete transcript with current interim result
            final fullTranscript = ('$_completeTranscript $_lastInterimResult').trim();
            _onTranscript?.call(fullTranscript);

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
      print('Error starting recognition: $e');
      _isListening = false;
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _streamSubscription?.cancel();
      _streamSubscription = null;
      _isListening = false;
      
      // If there's any interim result when stopping, add it to complete transcript
      if (_lastInterimResult.isNotEmpty) {
        _completeTranscript += ' $_lastInterimResult';
        _lastInterimResult = '';
        _onTranscript?.call(_completeTranscript.trim());
      }
    } catch (e) {
      print('Error stopping recognition: $e');
    }
  }

  void dispose() {
    stopListening();
    _speechToText = null;
  }
}
