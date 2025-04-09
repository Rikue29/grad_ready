import 'package:flutter/material.dart';
import '../services/speech_recognition_service.dart';
import '../services/gemini_analysis_service.dart';
import 'package:avatar_glow/avatar_glow.dart';

class LivePresentationPage extends StatefulWidget {
  const LivePresentationPage({Key? key}) : super(key: key);

  @override
  _LivePresentationPageState createState() => _LivePresentationPageState();
}

class _LivePresentationPageState extends State<LivePresentationPage> {
  final _speechService = SpeechRecognitionService();
  final _geminiService = GeminiAnalysisService();
  String _transcriptText = 'Press the microphone button and start speaking';
  double _confidence = 1.0;
  bool _isInitialized = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysis;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeGemini();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeGemini() async {
    await _geminiService.initialize();
    await _geminiService.testConnection();
  }

  Future<void> _initializeSpeech() async {
    final available = await _speechService.initialize();
    setState(() {
      _isInitialized = available;
    });
  }

  Future<void> _analyzeTranscript() async {
    if (_transcriptText.isEmpty || _transcriptText == 'Press the microphone button and start speaking') {
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysis = null;
    });

    try {
      final analysis = await _geminiService.analyzeSpeech(_transcriptText);
      setState(() {
        _analysis = analysis;
      });
      // Scroll to analysis after a short delay
      await Future.delayed(const Duration(milliseconds: 300));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis failed: $e')),
      );
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
        _analysis = null;
      });
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
      await _analyzeTranscript();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2632),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        title: const Text(
          'Live Presentation',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildTranscriptCard(),
              const SizedBox(height: 24),
              if (_isAnalyzing)
                const Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B00)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing your presentation...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              if (_analysis != null) ...[
                _buildAnalysisResult(),
                const SizedBox(height: 100), // Space for FAB
              ],
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildMicButton(),
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
            'Your Speech',
            style: TextStyle(
              color: Color(0xFFFF6B00),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _transcriptText,
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
                    backgroundColor: isListening ? const Color(0xFFFF6B00) : const Color(0xFF2A3543),
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

  Widget _buildAnalysisResult() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
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
            'Analysis Results',
            style: TextStyle(
              color: Color(0xFFFF6B00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildScoreCards(),
          const SizedBox(height: 24),
          _buildFillerWords(),
          const SizedBox(height: 24),
          _buildPacingInfo(),
          const SizedBox(height: 24),
          _buildKeyPoints(),
          const SizedBox(height: 24),
          _buildImprovements(),
        ],
      ),
    );
  }

  Widget _buildScoreCards() {
    if (_analysis == null) return const SizedBox();
    
    return Row(
      children: [
        Expanded(
          child: _buildScoreCard(
            'Clarity',
            _analysis!['clarity_score'] ?? 0,
            Icons.volume_up,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildScoreCard(
            'Confidence',
            _analysis!['confidence_score'] ?? 0,
            Icons.psychology,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(String label, dynamic score, IconData icon) {
    final double scoreValue = score is int ? score.toDouble() : score;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3543),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${scoreValue.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFillerWords() {
    if (_analysis == null) return const SizedBox();
    
    final fillerWordsMap = _analysis!['filler_words'] as Map<String, dynamic>?;
    if (fillerWordsMap == null || fillerWordsMap.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Filler Words'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: fillerWordsMap.entries.map((entry) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF6B00)),
              ),
              child: Text(
                '${entry.key} (${entry.value})',
                style: const TextStyle(
                  color: Color(0xFFFF6B00),
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPacingInfo() {
    if (_analysis == null) return const SizedBox();
    
    final pacingFeedback = _analysis!['pacing_feedback'] as String?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Pacing'),
        const SizedBox(height: 12),
        Text(
          pacingFeedback ?? 'No pacing feedback available',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyPoints() {
    if (_analysis == null) return const SizedBox();
    
    final points = _analysis!['key_points'] as List<dynamic>?;
    if (points == null || points.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Key Points'),
        const SizedBox(height: 12),
        ...points.map((point) => _buildBulletPoint(point.toString())),
      ],
    );
  }

  Widget _buildImprovements() {
    if (_analysis == null) return const SizedBox();
    
    final improvements = _analysis!['improvements'] as List<dynamic>?;
    if (improvements == null || improvements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Suggested Improvements'),
        const SizedBox(height: 12),
        ...improvements.map((improvement) => _buildBulletPoint(improvement.toString())),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFFFF6B00),
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
