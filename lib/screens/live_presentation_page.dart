import 'package:flutter/material.dart';
import '../services/speech_recognition_service.dart';
import 'package:avatar_glow/avatar_glow.dart';

class LivePresentationPage extends StatefulWidget {
  const LivePresentationPage({Key? key}) : super(key: key);

  @override
  _LivePresentationPageState createState() => _LivePresentationPageState();
}

class _LivePresentationPageState extends State<LivePresentationPage> {
  final _speechService = SpeechRecognitionService();
  String _transcriptText = 'Press the button and start speaking';
  double _confidence = 1.0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    final available = await _speechService.initialize();
    setState(() {
      _isInitialized = available;
    });
  }

  void _listen() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available'),
        ),
      );
      return;
    }

    if (!_speechService.isListening) {
      await _speechService.startListening(
        onTranscript: (text) {
          setState(() {
            _transcriptText = text;
          });
        },
        onConfidenceUpdate: (confidence) {
          setState(() {
            _confidence = confidence;
          });
        },
      );
    } else {
      await _speechService.stopListening();
    }
    setState(() {}); // Update UI to reflect listening state
  }

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2632),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        title: Text(
          'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _speechService.isListening,
        glowColor: const Color(0xFFFF6B00),
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          backgroundColor: const Color(0xFFFF6B00),
          child: Icon(
            _speechService.isListening ? Icons.mic : Icons.mic_none,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
            _transcriptText,
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
