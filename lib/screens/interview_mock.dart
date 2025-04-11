import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../services/speech_recognition_service.dart';
import 'package:avatar_glow/avatar_glow.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _loadInterviewQuestion();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _speechService.dispose();
    super.dispose();
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
      final feedback =
          await GeminiService.getImprovementFeedback(_transcriptText);
      setState(() {
        aiFeedback = feedback ?? 'No feedback available.';
      });
      // Scroll to show feedback
      await Future.delayed(const Duration(milliseconds: 300));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1C2632), // Dark background like LivePresentationPage
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        title: const Text(
          'Mock Interview',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology, color: Colors.white),
            tooltip: 'Gemini AI Test',
            onPressed: () {
              Navigator.pushNamed(context, '/gemini-test');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildQuestionCard(),
              const SizedBox(height: 24),
              _buildTranscriptCard(),
              const SizedBox(height: 24),
              if (_isAnalyzing)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFFF6B00)),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing your response...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              _buildFeedbackCard(),
              const SizedBox(height: 100), // Space for the floating button
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildMicButton(),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B00).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6B00).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Question',
            style: TextStyle(
              color: Color(0xFFFF6B00),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            currentQuestion.isEmpty
                ? 'Loading question for ${widget.jobRole}...'
                : currentQuestion,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6B00).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Answer',
            style: TextStyle(
              color: Color(0xFFFF6B00),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _transcriptText.isEmpty
                ? 'Press the microphone button and start speaking'
                : _transcriptText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Feedback',
            style: TextStyle(
              color: Color(0xFFFF6B00),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            aiFeedback,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    final isListening = _speechService.isListening;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A3543),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isListening ? 'Tap to stop' : 'Tap to speak',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                AvatarGlow(
                  endRadius: 32,
                  animate: isListening,
                  duration: const Duration(milliseconds: 2000),
                  glowColor: const Color(0xFFFF6B00),
                  child: FloatingActionButton(
                    onPressed: _listen,
                    backgroundColor: isListening
                        ? const Color(0xFFFF6B00)
                        : const Color(0xFF2A3543),
                    elevation: 0,
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
