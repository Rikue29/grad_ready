import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../services/speech_recognition_service.dart';

class InterviewMockScreen extends StatefulWidget {
  final String jobRole;

  const InterviewMockScreen({super.key, required this.jobRole});

  @override
  State<InterviewMockScreen> createState() => _InterviewMockScreenState();
}

class _InterviewMockScreenState extends State<InterviewMockScreen> {
  final _speechService = SpeechRecognitionService();
  String currentQuestion = '';
  String _transcriptText = '';
  bool _isInitialized = false;
  bool _isAnalyzing = false;
  String aiFeedback = 'Your AI review will appear here after you answer.';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _loadInterviewQuestion();
  }

  Future<void> _initializeSpeech() async {
    final available = await _speechService.initialize();
    setState(() {
      _isInitialized = available;
    });
  }

  Future<void> _loadInterviewQuestion() async {
    final question = await GeminiService.getInterviewQuestion(widget.jobRole);
    setState(() {
      currentQuestion = question?.isNotEmpty == true
          ? question!
          : 'Could not load question for the role of ${widget.jobRole}.';
    });
  }

  Future<void> _analyzeTranscript() async {
    if (_transcriptText.isEmpty) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
      aiFeedback = 'Analyzing your response...';
    });

    try {
      final feedback = await GeminiService.getImprovementFeedback(_transcriptText);
      setState(() {
        aiFeedback = feedback ?? 'No feedback available.';
      });
    } catch (e) {
      setState(() {
        aiFeedback = 'Analysis failed: $e';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
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
      setState(() {
        _transcriptText = '';
        aiFeedback = 'Listening...';
      });
      await _speechService.startListening(
        onTranscript: (text) {
          setState(() {
            _transcriptText = text;
          });
        },
      );
    } else {
      await _speechService.stopListening();
      await _analyzeTranscript();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6B00), // System-wide orange color
      appBar: AppBar(
        title: const Text(
          'Mock Interview',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/texture.png',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.2), // Adjust opacity
              colorBlendMode: BlendMode.srcOut, // Blend mode to apply the white color
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  currentQuestion.isEmpty
                      ? 'Loading question for ${widget.jobRole}...'
                      : currentQuestion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white, // Main text color
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200]?.withOpacity(0.9), // Slight transparency
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isAnalyzing
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                          aiFeedback,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.left,
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Centered microphone button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  onPressed: _listen,
                  backgroundColor: Colors.white,
                  elevation: 10,
                  child: Icon(
                    _speechService.isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}