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
  String _transcriptText = 'Press the button and start speaking';
  double _confidence = 1.0;
  bool _isInitialized = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysis;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeGemini();
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
    if (_transcriptText.isEmpty || _transcriptText == 'Press the button and start speaking') {
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
      // Analyze the transcript after stopping
      await _analyzeTranscript();
    }
    setState(() {}); // Update UI to reflect listening state
  }

  Widget _buildAnalysisResult() {
    if (_analysis == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2632),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_analysis!.containsKey('clarity_score'))
            _buildScoreRow('Clarity Score', _analysis!['clarity_score']),
          if (_analysis!.containsKey('filler_words')) ...[
            const SizedBox(height: 16),
            _buildFillerWords(),
          ],
          if (_analysis!.containsKey('pacing_feedback')) ...[
            const SizedBox(height: 16),
            _buildPacingInfo(),
          ],
          if (_analysis!.containsKey('key_points')) ...[
            const SizedBox(height: 16),
            _buildKeyPoints(),
          ],
          if (_analysis!.containsKey('improvements')) ...[
            const SizedBox(height: 16),
            _buildImprovements(),
          ],
          if (_analysis!.containsKey('confidence_score')) ...[
            const SizedBox(height: 16),
            _buildScoreRow('Confidence Score', _analysis!['confidence_score']),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, dynamic score) {
    // Convert score to double
    final double scoreValue = score is int ? score.toDouble() : (score as double);
    
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF6B00),
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              '${(scoreValue * 100).round()}',
              style: const TextStyle(
                color: Color(0xFFFF6B00),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFillerWords() {
    final fillerWordsMap = _analysis!['filler_words'] as Map<String, dynamic>;
    if (fillerWordsMap.isEmpty) return const SizedBox.shrink();

    final List<MapEntry<String, dynamic>> fillerWords = fillerWordsMap.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filler Words Used:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: fillerWords
              .map((entry) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFF6B00),
                      ),
                    ),
                    child: Text(
                      '${entry.key} (${entry.value})',
                      style: const TextStyle(
                        color: Color(0xFFFF6B00),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPacingInfo() {
    final pacingFeedback = _analysis!['pacing_feedback'] as String? ?? 'No pacing feedback available';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pacing Analysis:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          pacingFeedback,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyPoints() {
    final keyPoints = _analysis!['key_points'] as List<dynamic>? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Points:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        if (keyPoints.isEmpty)
          const Text(
            'No key points identified',
            style: TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ...keyPoints.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
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
                        point.toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  Widget _buildImprovements() {
    final improvements = _analysis!['improvements'] as List<dynamic>? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suggested Improvements:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        if (improvements.isEmpty)
          const Text(
            'No improvements suggested',
            style: TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ...improvements.map((improvement) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
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
                        improvement.toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
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
        iconTheme: const IconThemeData(
          color: Color(0xFFFF6B00),
        ),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: Text(
                _transcriptText,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            if (_isAnalyzing)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6B00),
                ),
              ),
            _buildAnalysisResult(),
            const SizedBox(height: 100), // Space for the floating button
          ],
        ),
      ),
    );
  }
}
