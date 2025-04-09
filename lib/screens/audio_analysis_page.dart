import 'package:flutter/material.dart';

class AudioAnalysisPage extends StatefulWidget {
  const AudioAnalysisPage({super.key});

  @override
  State<AudioAnalysisPage> createState() => _AudioAnalysisPageState();
}

class _AudioAnalysisPageState extends State<AudioAnalysisPage> {
  final List<ChatMessage> _messages = [];
  bool _isAnalyzing = false;
  String? _mockFileName;

  Future<void> _simulateFileUpload() async {
    setState(() => _isAnalyzing = true);
    
    // Simulate file selection
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _mockFileName = 'presentation_recording.mp3';
      _messages.add(
        ChatMessage(
          content: "Selected file: presentation_recording.mp3",
          isUser: true,
        ),
      );
    });

    // Simulate upload progress
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _messages.add(
        ChatMessage(
          content: "Uploading audio file...",
          isUser: false,
        ),
      );
    });

    // Simulate processing start
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _messages.add(
        ChatMessage(
          content: "Processing your presentation... This might take a moment.",
          isUser: false,
        ),
      );
    });

    // Simulate analysis
    await Future.delayed(const Duration(seconds: 2));

    final analysisResult = {
      'clarity_score': 0.85,
      'confidence_score': 0.78,
      'filler_words': {
        'um': 5,
        'uh': 3,
        'like': 7,
        'you know': 4,
      },
      'pacing_feedback': 'Your speaking pace is good, averaging 130 words per minute. The pace varies appropriately between technical explanations and key points.',
      'key_points': [
        'Clear introduction of the project goals',
        'Detailed explanation of technical architecture',
        'Strong emphasis on user benefits',
        'Well-structured conclusion with next steps',
      ],
      'improvements': [
        'Consider reducing filler words, particularly "like" and "you know"',
        'Add more pauses after key technical points for better audience comprehension',
        'Include more concrete examples when discussing benefits',
        'Could improve transition between sections',
      ],
    };

    setState(() {
      _messages.add(
        ChatMessage(
          content: _formatAnalysis(analysisResult),
          isUser: false,
          isAnalysis: true,
        ),
      );
      _isAnalyzing = false;
    });
  }

  String _formatAnalysis(Map<String, dynamic> analysis) {
    return '''
📊 Analysis Results:

Clarity Score: ${(analysis['clarity_score'] * 100).round()}%
Confidence Score: ${(analysis['confidence_score'] * 100).round()}%

🗣 Filler Words Used:
${(analysis['filler_words'] as Map<String, dynamic>).entries.map((e) => '• "${e.key}": ${e.value} times').join('\n')}

⏱ Pacing:
${analysis['pacing_feedback']}

✨ Key Points:
${(analysis['key_points'] as List).map((point) => '• $point').join('\n')}

🎯 Areas for Improvement:
${(analysis['improvements'] as List).map((point) => '• $point').join('\n')}
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2632),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        title: const Text(
          'Audio Analysis',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          if (_isAnalyzing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                backgroundColor: Color(0xFF1C2632),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B00)),
              ),
            ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFFFF6B00) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.white.withOpacity(0.9),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _mockFileName ?? 'No file selected',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _isAnalyzing ? null : _simulateFileUpload,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.upload_file),
            label: Text(_mockFileName == null ? 'Upload Audio' : 'Analyze'),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final bool isAnalysis;

  ChatMessage({
    required this.content,
    required this.isUser,
    this.isAnalysis = false,
  });
}
