import 'package:flutter/material.dart';
import 'package:gradready_interview/screens/splash_screen.dart';
import 'screens/homepage.dart'; // Ensure this file exists and is correct
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login.dart';
import 'screens/presentation_homepage.dart';
import 'screens/gemini_test_page.dart';
import 'screens/audio_analysis_page.dart';
import 'services/env_config_service.dart';
import 'package:gradready_interview/screens/interview_role.dart';
import 'package:google_fonts/google_fonts.dart';
// added import statement

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EnvConfigService.initialize();
  await dotenv.load();

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
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/presentation': (context) => const PresentationHomePage(),
        '/gemini-test': (context) => const GeminiTestPage(),
        '/audio-analysis': (context) => const AudioAnalysisPage(),
        '/interview': (context) => const InterviewRoleScreen(),
        '/splashpage': (context) => const SplashScreen(),
      },
    );
  }
}
