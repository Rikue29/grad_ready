import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../widgets/custom_navbar.dart';
import '../services/stt_service.dart';
import '../services/gemini_service.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final recorder = AudioRecorder();
  final TextEditingController roleController = TextEditingController();
  bool isRecording = false;
  String? recordedFilePath;
  String aiFeedback = 'Your AI review will appear here after recording.';
  String currentQuestion = 'Enter a job role to get started.';
  String jobRole = '';

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

  Future<void> _startRecording() async {
    print('[DEBUG] Requesting mic permission...');
    if (await recorder.hasPermission()) {
      print('[DEBUG] Permission granted.');
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/response.wav';

      print('[DEBUG] Starting recording with mono config at: $path');
      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.flac,
          sampleRate: 16000,
          bitRate: 128000,
          numChannels: 1,
        ),
        path: path,
      );

      setState(() {
        isRecording = true;
        recordedFilePath = path;
      });
    } else {
      print('[DEBUG] Microphone permission denied.');
    }
  }

  Future<void> _stopRecording() async {
    print('[DEBUG] Stopping recording...');
    await recorder.stop();
    setState(() {
      isRecording = false;
      aiFeedback = 'Analyzing...';
    });

    if (recordedFilePath != null) {
      final file = File(recordedFilePath!);
      print('[DEBUG] File exists: ${file.existsSync()}');
      print('[DEBUG] File path: $recordedFilePath');
      print('[DEBUG] File size: ${file.lengthSync()} bytes');

      final transcript = await STTService.transcribeAudio(file);
      print('[DEBUG] Transcribed text: $transcript');

      if (transcript != null && transcript.isNotEmpty) {
        final feedback = await GeminiService.getImprovementFeedback(transcript);
        print('[DEBUG] Gemini Feedback: $feedback');

        setState(() {
          aiFeedback = feedback ?? 'No feedback available.';
        });
      } else {
        setState(() {
          aiFeedback = 'Sorry, no speech detected.';
        });
        print('[DEBUG] No transcript returned.');
      }
    } else {
      setState(() {
        aiFeedback = 'No audio file found.';
      });
      print('[DEBUG] No file path set.');
    }
  }

  void _nextQuestion() {
    setState(() {
      currentQuestion = 'Loading next question...';
      aiFeedback = 'Your AI review will appear here after recording.';
    });
    _loadInterviewQuestion();
  }

  @override
  void dispose() {
    recorder.dispose();
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
              Center(
                child: GestureDetector(
                  onTap: isRecording ? _stopRecording : _startRecording,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: isRecording ? Colors.red : Colors.orange,
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap the mic icon to start recording your response.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 30),
              const Text(
                'AI Feedback:',
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      aiFeedback,
                      style: const TextStyle(color: Colors.black),
                    ),
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
