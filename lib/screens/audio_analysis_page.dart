import 'package:flutter/material.dart';
import 'dart:io';

class AudioAnalysisPage extends StatefulWidget {
  const AudioAnalysisPage({super.key});

  @override
  State<AudioAnalysisPage> createState() => _AudioAnalysisPageState();
}

class _AudioAnalysisPageState extends State<AudioAnalysisPage> {
  bool _isAnalyzing = false;
  File? _audioFile;
  Map<String, dynamic>? _analysis;
  String _status = 'No file selected';

  Future<void> _pickAudioFile() async {
    // TODO: Implement file picking
    setState(() {
      _status = 'Selected audio file: example.mp3';
    });
  }

  Future<void> _analyzeAudio() async {
    if (_audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an audio file first')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysis = null;
    });

    // TODO: Implement actual audio analysis
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay

    // Simulated analysis result
    setState(() {
      _isAnalyzing = false;
      _analysis = {
        'clarity_score': 0.85,
        'confidence_score': 0.78,
        'filler_words': {
          'um': 3,
          'uh': 2,
          'like': 4,
        },
        'pacing_feedback': 'Good pace with clear articulation. Consider slowing down slightly during technical explanations.',
        'key_points': [
          'Introduction to the main topic',
          'Discussion of key features',
          'Summary of benefits',
        ],
        'improvements': [
          'Reduce usage of filler words',
          'Add more pauses for emphasis',
          'Provide more specific examples',
        ],
      };
    });
  }

  Widget _buildUploadSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2632),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _audioFile == null ? Icons.upload_file : Icons.audio_file,
            size: 64,
            color: const Color(0xFFFF6B00),
          ),
          const SizedBox(height: 16),
          Text(
            _status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _pickAudioFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.file_upload, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Select Audio File',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (_audioFile != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isAnalyzing ? null : _analyzeAudio,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isAnalyzing ? Icons.hourglass_empty : Icons.analytics,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isAnalyzing ? 'Analyzing...' : 'Analyze Audio',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
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
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, dynamic score) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2632),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        iconTheme: const IconThemeData(
          color: Color(0xFFFF6B00),
        ),
        title: const Text(
          'Audio Analysis',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUploadSection(),
            if (_isAnalyzing)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF6B00),
                  ),
                ),
              ),
            _buildAnalysisResult(),
          ],
        ),
      ),
    );
  }
}
