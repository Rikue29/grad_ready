import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';
import '../services/gemini_service.dart';
import '../services/speech_recognition_service.dart';
import 'package:avatar_glow/avatar_glow.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final TextEditingController roleController = TextEditingController();
  final _speechService = SpeechRecognitionService();
  String currentQuestion = 'Enter a job role to get started.';
  String jobRole = '';
  String _transcriptText = '';
  bool _isInitialized = false;
  bool _isAnalyzing = false;
  String aiFeedback = 'Your AI review will appear here after recording.';

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

  Future<void> _loadInterviewQuestion() async {
    if (jobRole.isEmpty) {
      setState(() {
        currentQuestion = 'Please enter a job role.';
      });
      return;
    }

    final question = await GeminiService.getInterviewQuestion(jobRole);
    print('[DEBUG] AI Response for $jobRole: $question');

    setState(() {
      currentQuestion = (question?.isNotEmpty == true
          ? question
          : 'Could not load question for the role of $jobRole.')!;
    });
  }

  Future<void> _checkGeminiApi() async {
    final testPrompt = 'test';
    final response = await GeminiService.getInterviewQuestion(testPrompt);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gemini API Status'),
        content: Text(
          response?.isNotEmpty == true
              ? '✅ Gemini API is working!\n\nResponse: $response'
              : '❌ Gemini API did not return a valid response.',
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
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
        onConfidenceUpdate: (confidence) {
          // You can use confidence score if needed
        },
      );
    } else {
      await _speechService.stopListening();
      // Analyze the transcript after stopping
      await _analyzeTranscript();
    }
    setState(() {}); // Update UI to reflect listening state
  }

  void _nextQuestion() {
    setState(() {
      currentQuestion = 'Loading next question...';
      aiFeedback = 'Your AI review will appear here after recording.';
      _transcriptText = '';
    });
    _loadInterviewQuestion();
  }

  @override
  void dispose() {
    _speechService.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Interview Practice',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: roleController,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  setState(() {
                    jobRole = value.trim();
                    currentQuestion = 'Loading question for $jobRole...';
                  });
                  _loadInterviewQuestion();
                },
                decoration: const InputDecoration(
                  hintText: 'Enter a job role (e.g. UI Designer)',
                  border: OutlineInputBorder(),
                  labelText: 'Job Role',
                ),
              ),
              TextButton(
                onPressed: _checkGeminiApi,
                child: const Text('Check Gemini API'),
              ),
              const SizedBox(height: 16),
              Text(
                currentQuestion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _nextQuestion,
                child: const Text('Next Question'),
              ),
              const SizedBox(height: 20),
              Text(
                _transcriptText.isEmpty ? 'Press the mic button and start speaking'
                    : _transcriptText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              AvatarGlow(
                animate: _speechService.isListening,
                glowColor: Theme.of(context).primaryColor,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: FloatingActionButton(
                  onPressed: _listen,
                  child: Icon(_speechService.isListening ? Icons.mic : Icons.mic_none),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isAnalyzing
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                        aiFeedback,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // TODO: Add navigation logic later
        },
      ),
    );
  }
}
