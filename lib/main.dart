import 'package:flutter/material.dart';
import 'package:gradready_interview/screens/interview_role.dart';
import 'screens/presentation_homepage.dart';
import 'screens/gemini_test_page.dart';
import 'services/env_config_service.dart';
import 'screens/audio_analysis_page.dart'; // added import statement
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/interview_mock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfigService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradReady',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6B00),
        scaffoldBackgroundColor: const Color(0xFF1C2632),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PresentationHomePage(),
        '/gemini-test': (context) => const GeminiTestPage(),
        '/audio-analysis': (context) => const AudioAnalysisPage(),
        '/interview': (context) => const InterviewRoleScreen(),
      },
    );
  }
}
