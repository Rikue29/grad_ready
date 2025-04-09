import 'dart:async';
import 'package:flutter/services.dart';

class AudioStreamService {
  static const _methodChannel =
      MethodChannel('com.example.grad_ready/audio_stream');
  static const _eventChannel =
      EventChannel('com.example.grad_ready/audio_stream_events');
  static StreamSubscription? _streamSubscription;

  static Future<Stream<List<int>>> getAudioStream() async {
    try {
      print('Starting audio stream...');
      await _methodChannel.invokeMethod('startAudioStream');
      print('Audio stream started successfully');

      final stream =
          _eventChannel.receiveBroadcastStream().map((dynamic event) {
        if (event is List<int>) {
          print('Received audio data: ${event.length} bytes');
          return event;
        }
        print('Received invalid audio data format');
        throw Exception('Invalid audio data format');
      });

      return stream;
    } catch (e) {
      print('Error starting audio stream: $e');
      rethrow;
    }
  }

  static Future<void> stopAudioStream() async {
    try {
      print('Stopping audio stream...');
      await _methodChannel.invokeMethod('stopAudioStream');
      await _streamSubscription?.cancel();
      _streamSubscription = null;
      print('Audio stream stopped successfully');
    } catch (e) {
      print('Error stopping audio stream: $e');
      rethrow;
    }
  }
}
