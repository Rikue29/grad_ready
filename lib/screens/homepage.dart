import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import '../widgets/custom_navbar.dart';
import 'presentation_homepage.dart';
import 'interview_role.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePageStateful(),
    );
  }
}

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  int _currentIndex = 1; // Start with Home tab selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6B00), // Orange background
      body: const HomeContent(),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Handle navigation based on index
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                break;
              case 1:
                // Already on home page
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
                break;
            }
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          const SizedBox(height: 16),
          _buildWeekTracker(),
          const SizedBox(height: 90),
          const Center(
            child: Text(
              "Choose Your Mode:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildModeSelection(context),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF10182F),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TOTAL XP\n7,176 XP',
            style: TextStyle(color: Colors.orange, fontSize: 18),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 6),
                Text('2 days', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekTracker() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final icons = [
      Icons.circle,
      Icons.circle,
      Icons.circle,
      Icons.circle,
      Icons.circle,
      Icons.circle,
      Icons.circle,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          return Column(
            children: [
              Icon(
                icons[index],
                color: index < 5 ? Colors.orange : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                days[index],
                style: TextStyle(
                  color: index < 5 ? Colors.orange : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildModeSelection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildModeCard(
              "Presentation",
              imagePath: 'assets/img/presentation.jpg',
              context: context,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildModeCard(
              "Interview",
              imagePath: 'assets/img/interviewperson.jpg',
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard(String title,
      {required String imagePath, required BuildContext context}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Handle mode selection
          if (title == "Presentation") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const PresentationHomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const InterviewRoleScreen()),
            );
          }
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
