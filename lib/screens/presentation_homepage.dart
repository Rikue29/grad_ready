import 'package:flutter/material.dart';
import 'gcp_test_page.dart';
import 'live_presentation_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import '../widgets/custom_navbar.dart';

class PresentationHomePage extends StatelessWidget {
  const PresentationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6B00), // Orange background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B00),
        title: const Text(
          "GradReady",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud, color: Colors.white),
            tooltip: 'GCP Test',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GcpTestPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.psychology, color: Colors.white),
            tooltip: 'Gemini AI Test',
            onPressed: () {
              Navigator.pushNamed(context, '/gemini-test');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/texture.png',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.2),
              colorBlendMode: BlendMode.srcOut,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pick an option to begin",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildTile(
                        context,
                        icon: Icons.question_answer,
                        title: "Interview Practice",
                        description: "Prepare for your interviews.",
                        onTap: () {
                          Navigator.pushNamed(context, '/interview');
                        },
                      ),
                      _buildTile(
                        context,
                        icon: Icons.videocam,
                        title: "Live Presentation",
                        description: "Practice live presentations.",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LivePresentationPage(),
                            ),
                          );
                        },
                      ),
                      _buildTile(
                        context,
                        icon: Icons.upload_file,
                        title: "Upload File",
                        description: "Analyze your files.",
                        onTap: () {
                          Navigator.pushNamed(context, '/audio-analysis');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1, // Set to 1 as this is the Presentation Homepage
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(
                context, '/profile'); // Navigate to Profile Page
          } else if (index == 1) {
            // Stay on the current page
          } else if (index == 2) {
            Navigator.pushNamed(
                context, '/settings'); // Navigate to Settings Page
          }
        },
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C2632),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
