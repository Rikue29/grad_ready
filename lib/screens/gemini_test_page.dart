import 'package:flutter/material.dart';
import '../services/gemini_analysis_service.dart';

class GeminiTestPage extends StatefulWidget {
  const GeminiTestPage({super.key});

  @override
  State<GeminiTestPage> createState() => _GeminiTestPageState();
}

class _GeminiTestPageState extends State<GeminiTestPage> {
  final _service = GeminiAnalysisService();
  final _textController = TextEditingController();
  bool _isLoading = false;
  String _status = 'Not initialized';
  Map<String, dynamic>? _analysis;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing...';
    });

    try {
      await _service.initialize();
      final success = await _service.testConnection();
      setState(() {
        _status = success ? '✅ Ready to analyze!' : '❌ Connection failed';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _analyzeText() async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text to analyze')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _analysis = null;
    });

    try {
      final analysis = await _service.analyzeSpeech(_textController.text);
      setState(() {
        _analysis = analysis;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildAnalysisResult() {
    if (_analysis == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2632),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreRow('Clarity Score', _analysis!['clarity_score']),
          const SizedBox(height: 16),
          _buildFillerWords(),
          const SizedBox(height: 16),
          _buildPacingInfo(),
          const SizedBox(height: 16),
          _buildKeyPoints(),
          const SizedBox(height: 16),
          _buildImprovements(),
          const SizedBox(height: 16),
          _buildScoreRow('Confidence Score', _analysis!['confidence_score']),
          const SizedBox(height: 16),
          Text(
            'Overall Feedback:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _analysis!['overall_feedback'] ?? 'No feedback available',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, dynamic score) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$score/100',
          style: const TextStyle(
            color: Color(0xFFFF6B00),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFillerWords() {
    final fillerWords = _analysis!['filler_words'];
    if (fillerWords == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filler Words (${fillerWords['count']}):',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: (fillerWords['words'] as List<dynamic>)
              .map((word) => Chip(
                    label: Text(word),
                    backgroundColor: const Color(0xFFFF6B00).withOpacity(0.2),
                    labelStyle: const TextStyle(color: Colors.white),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Text(
          fillerWords['improvement_suggestion'] ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPacingInfo() {
    final pacing = _analysis!['pacing'];
    if (pacing == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pacing:',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${pacing['words_per_minute']} words/minute - ${pacing['assessment']}',
          style: const TextStyle(color: Color(0xFFFF6B00), fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          pacing['suggestion'] ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildKeyPoints() {
    final keyPoints = _analysis!['key_points'] as List<dynamic>?;
    if (keyPoints == null || keyPoints.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Points:',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: keyPoints
              .map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: Color(0xFFFF6B00))),
                        Expanded(
                          child: Text(point,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14)),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildImprovements() {
    final improvements = _analysis!['improvements'] as List<dynamic>?;
    if (improvements == null || improvements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Areas for Improvement:',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: improvements
              .map((improvement) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: Color(0xFFFF6B00))),
                        Expanded(
                          child: Text(improvement,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14)),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2632),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        title: const Text(
          'Gemini AI Test',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2632),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Text(
                    _status,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (_isLoading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(
                      color: Color(0xFFFF6B00),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter presentation text to analyze...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: const Color(0xFF1C2632),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFF6B00)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _analyzeText,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Analyze',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildAnalysisResult(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
